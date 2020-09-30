FROM php:7.2-fpm

RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-install -j$(nproc) iconv \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd

RUN apt-get update && apt-get install npm supervisor -y

RUN docker-php-ext-install pcntl pdo pdo_mysql zip

# # # @TODO: ver pq tá dando erro
# # RUN docker-php-ext-install libsodium intl 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html/lessclick

COPY ./lessclick/package*.json ./
COPY ./lessclick/composer*.json ./

WORKDIR /var/www/html/

# config do supervisor
# COPY ./supervisor/supervisord.conf /etc/supervisord.conf

# config do horizon
# COPY ./supervisor/horizon.conf /etc/supervisor/conf.d/horizon.conf

RUN mkdir /var/www/html/supervisor
RUN touch /var/www/html/supervisor/supervisord.log

# # executando o supervisor
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# # COPY ./supervisor/horizon.conf /etc/supervisor/conf.d/horizon.conf
# # CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/horizon.conf"]