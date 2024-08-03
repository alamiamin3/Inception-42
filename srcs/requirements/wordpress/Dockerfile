FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php-fpm \
    curl \
    php-mysqli \
    sudo

RUN mkdir -p /run/php


COPY ./tools /tools

WORKDIR /tools

RUN chmod +x script.sh

CMD ./script.sh