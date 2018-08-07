MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --warn-undefined-variables

PROJECTPATH = $(HOME)/path/to/project
SUFFIX = ""
CONTAINER = niklas-heer/php7-compatibility-checker:latest
VENDORPATH = /usr/local/lib/php-research/vendor
RESULTSPATH = $(PWD)/results
APPSRC = /app/src
APPRESULTS = /app/results

ts := `/bin/date "+%Y-%m-%d--%H-%M-%S"`

.PHONY: build
build:
	docker build -t niklas-heer/php7-compatibility-checker .

.PHONY: phpcs
phpcs:
	docker run -it -v $(PROJECTPATH):$(APPSRC) -v $(RESULTSPATH):$(APPRESULTS) -w $(APPSRC) $(CONTAINER) php $(VENDORPATH)/bin/phpcs -d memory_limit=1G -sv --runtime-set installed_paths $(VENDORPATH)/wimg/php-compatibility --standard='PHPCompatibility' --extensions=php --ignore=vendor --warning-severity=0 --report-file=$(APPRESULTS)/$(ts)_phpcs-results_$(SUFFIX).txt . || true

.PHONY: php7cc
php7cc:
	docker run -it -v $(PROJECTPATH):$(APPSRC) -v $(RESULTSPATH):$(APPRESULTS) -w $(APPSRC) $(CONTAINER) php $(VENDORPATH)/bin/php7cc -l . --exclude-directory-list "vendor/" > $(APPRESULTS)/$(ts)_phan-results.txt

.PHONY: fix-permissions
fix-permissions:
	docker run -it -v $(RESULTSPATH):$(APPRESULTS) -w $(APPRESULTS) $(CONTAINER) find . -path './data' -prune -o -exec chown -c $$(id -u):$$(id -g) {} \;

.PHONY: bash
bash:
	docker run -it -v $(PROJECTPATH):$(APPSRC) -v $(RESULTSPATH):$(APPRESULTS) -w $(APPSRC) $(CONTAINER) /bin/bash
