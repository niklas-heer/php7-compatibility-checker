#!/bin/sh

php /usr/local/lib/php-research/composer.phar "$@"
STATUS=$?
return $STATUS
