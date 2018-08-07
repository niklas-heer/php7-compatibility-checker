FROM php:7.2-cli

LABEL maintainer="me@nheer.io"

ENV TARGET_DIR="/usr/local/lib/php-research" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    TIMEZONE=Europe/Berlin \
    PHP_MEMORY_LIMIT=512M

RUN mkdir -p $TARGET_DIR

WORKDIR $TARGET_DIR

COPY composer-installer.sh $TARGET_DIR/
COPY composer-wrapper.sh /usr/local/bin/composer

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y zip && \
    apt-get install -y git && \
    apt-get install -y libxml2-dev && \
    docker-php-ext-install xml

# add php-ast extension needed by phan/phan
RUN cd $TARGET_DIR && \
    git clone https://github.com/nikic/php-ast.git && \
    cd php-ast && \
    phpize && \
    ./configure --enable-ast && \
    make install && \
    docker-php-ext-enable ast

RUN chmod 744 $TARGET_DIR/composer-installer.sh
RUN chmod 744 /usr/local/bin/composer

# Run composer installation of needed tools
RUN $TARGET_DIR/composer-installer.sh && \
   composer selfupdate && \
   composer require --prefer-stable --prefer-source "hirak/prestissimo:^0.3" && \
   composer require --prefer-stable --prefer-dist \
        "squizlabs/php_codesniffer:^3.0" \
        "wimg/php-compatibility:^8.1" \
        # "phan/phan:^0.11" \
        "wapmorgan/php-code-fixer:^2.0" \
        "sstalle/php7cc:^1.2.1"
