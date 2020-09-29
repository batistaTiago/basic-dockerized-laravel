FROM php:7.2-fpm-alpine

RUN docker-php-ext-install pdo pdo_mysql

# Setup GD extension
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev

RUN docker-php-ext-install gd

RUN docker-php-ext-install zip

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk add --update npm

# # @TODO: ver pq tá dando erro
# RUN docker-php-ext-install libsodium intl 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html/src

COPY ./src/package*.json ./
COPY ./src/composer*.json ./

WORKDIR /var/www/html/