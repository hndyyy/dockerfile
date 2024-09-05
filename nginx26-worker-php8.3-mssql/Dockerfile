FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
# Install tool pendukung
RUN apt-get update
RUN apt-get install -y sudo \
        curl \
        wget \
        nano \
        htop \
        unzip \
        git \
        redis-tools \
        mysql-client \
        apt-utils \
        openssh-server
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN add-apt-repository ppa:ondrej/nginx
# Install NGINX
RUN apt-get -y update
RUN apt-get install -y nginx-full
# Install PHP 8.1-FPM
RUN apt-get install -y php8.3-fpm
RUN apt-get install -y php8.3-curl \
        php8.3-gmp \
        php8.3-mysql \
        php8.3-common \
        php8.3-cli \
        php8.3-gd \
        php8.3-opcache \
        php8.3-imagick \
        php8.3-mbstring \
        php8.3-xml \
        php8.3-zip \
        php8.3-redis \
        php8.3-gettext \
        php8.3-ctype \
        php8.3-tokenizer \
        php8.3-MySqli \
        php8.3-MySqlND \
        php8.3-pdo \
        php8.3-pgsql 
## Konfigurasi NGINX + PHP
RUN mkdir /etc/nginx/ssl/
RUN mkdir /var/www/html/prod/
RUN mkdir /var/www/html/dev/
RUN echo "<?php phpinfo();?>" >> /var/www/html/prod/index.php
COPY config/nginx/php.default.conf /etc/nginx/php.conf.d/
COPY config/nginx/limiter.conf /etc/nginx/conf.d/
COPY config/nginx/default /etc/nginx/sites-enabled/
# Php config
RUN rm /etc/php/8.3/fpm/php.ini
COPY config/php.ini /etc/php/8.3/fpm
# Install Supervisord
RUN apt-get install -y supervisor
COPY config/supervisord.conf /etc/supervisor
# Install Composer
RUN curl –sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
# Config by Script
ADD config  /config
RUN chmod -R +x /config
# Install mssql Driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN apt-get install -y unixodbc-dev
RUN apt-get -y install gcc g++ make autoconf libc-dev pkg-config
RUN apt install -y php8.3-dev php-pear
RUn pecl install sqlsrv pdo_sqlsrv
RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.3/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.3/mods-available/pdo_sqlsrv.ini
RUN phpenmod -v 8.3 sqlsrv pdo_sqlsrv
# Server Variable
### Timezone 
ARG TIMEZONE=Asia/Jakarta
ENV TIMEZONE=$TIMEZONE
### SSH Service
ARG SSH_SERVICE=start
ENV SSH_SERVICE=$SSH_SERVICE
ARG SSH_USER=user
ENV SSH_USER=$SSH_USER
ARG SSH_PASSWORD=password
ENV SSH_PASSWORD=$SSH_PASSWORD
### PHP Variable
ARG POST_MAX_SIZE=10M
ENV POST_MAX_SIZE=$POST_MAX_SIZE
ARG MEMORY_LIMIT=256M
ENV MEMORY_LIMIT=$MEMORY_LIMIT
ARG MAX_INPUT_VARS=2000
ENV MAX_INPUT_VARS=$MAX_INPUT_VARS
ARG UPLOAD_MAX_FILESIZE=10M
ENV UPLOAD_MAX_FILESIZE=$UPLOAD_MAX_FILESIZE
ARG MAX_EXECUTION_TIME=60
ENV MAX_EXECUTION_TIME=$MAX_EXECUTION_TIME
ARG MAX_INPUT_TIME=120
ENV MAX_INPUT_TIME=$MAX_INPUT_TIME
# Pointing
WORKDIR /var/www/html
ENTRYPOINT ["/config/runner.sh"]
CMD nginx -g 'daemon off;'
