FROM php:7.2-fpm

RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		npm \
		cron \
		nano \
		zip \
		unzip \
		zlib1g-dev \
		libzip-dev \
	&& docker-php-ext-install -j$(nproc) iconv \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install zip

RUN docker-php-ext-install pcntl pdo pdo_mysql zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html/src

COPY ./src/package*.json ./
COPY ./src/composer*.json ./

WORKDIR /var/www/html/

# Create the log file to be able to run tail
RUN touch /tmp/cron.log

# Setup cron job
RUN (crontab -l ; echo "* * * * * cd /var/www/html && /usr/local/bin/php artisan schedule:run >> /tmp/cron.log") | crontab


RUN update-rc.d cron enable

RUN apt-get install git -y

RUN npm install -g npm