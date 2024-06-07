FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php-fpm \
    curl \
    php-mysqli



RUN mkdir -p /run/php


COPY ./tools/ .


CMD ./script.sh