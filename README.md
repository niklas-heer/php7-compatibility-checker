# PHP7 Compatibility checker

This repo contains:

- Docker image to check PHP code for compatibility to PHP versions. Including:
    - [wimg/php-compatibility](https://github.com/wimg/PHPCompatibility)
        - Leverages PHP_Codesniffer to "sniff" code for incompatible code to various versions of PHP. It then reports what version of PHP the code is broken with, and what version of PHP the code was broken by.
    - [sstalle/php7cc](https://github.com/sstalle/php7cc)
        - php7cc is a command line tool designed to make migration from PHP 5.3-5.6 to PHP 7 easier. It searches for potentially troublesome statements in existing code and generates reports containing file names, line numbers and short problem descriptions. It does not automatically fix code to work with the new PHP version.
    - [wapmorgan/PhpCodeFixer](https://github.com/wapmorgan/PhpCodeFixer)
        - Finds deprecated functions, wrong functions usage, variables, ini directives and restricted identifiers in php code. It literally helps you fix code that can fail after migration to PHP 7.

## Usage

### PHPCompatibility

More info on how to run this tool can be found at: https://github.com/wimg/PHPCompatibility

```
make phpcs
```

### PHP 7 Compatibility Checker

More info on how to run this tool can be found at: https://github.com/sstalle/php7cc

```
make php7cc
```

## Building the image

```
$ docker build -t niklas-heer/php7-compatibility-checker .
```
