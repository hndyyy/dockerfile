FROM quay.io/centos/centos:stream9

#Update Repository and install tools
RUN dnf -y update
RUN dnf install -y epel-release \
		   https://rpms.remirepo.net/enterprise/remi-release-9.rpm
RUN dnf module -y reset php
RUN dnf module -y enable php:remi-8.3
RUN dnf -y update
RUN dnf -y clean all && dnf -y update
RUN dnf -y install --allowerasing  sudo \
        curl \
        wget \
        nano \
        htop \
        unzip \
        git 
 
#Install PHP
RUN dnf -y install php \
		   php-fpm \
		   php-curl \
		   php-gmp \
		   php-mysqlnd \
		   php-common \
		   php-cli \
		   php-gd \
		   php-opcache \
		   php-imagick \
		   php-mbstring \
		   php-xml \
 		   php-zip \
		   php-redis \
		   php-gettext \
		   php-ctype \
		   php-tokenizer \
		   php-pdo \
		   php-intl \
		   php-pgsql \
		   nginx

#PHP and Nginx setup
RUN mkdir -p /etc/nginx/ssl/
RUN mkdir -p /var/www/html/prod/
RUN mkdir -p /var/www/html/dev/
RUN mkdir -p /etc/nginx/php.conf.d/
RUN echo "<?php phpinfo();?>" >> /var/www/html/prod/index.php

COPY config/nginx/default.conf /etc/nginx/conf.d/
COPY config/nginx/limiter.conf /etc/nginx/conf.d/
COPY config/nginx/php.default.conf /etc/nginx/php.conf.d/
COPY config/nginx/php.default.conf /etc/nginx/php.conf.d/

RUN rm -rf /etc/php.ini
COPY config/php.ini /etc/

#Install Supervisor
RUN dnf install -y supervisor
COPY config/supervisord.conf /etc/supervisord.conf

#Install Composer 
RUN curl –sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

#Config by Script
ADD config  /config
RUN chmod -R +x /config

RUN mkdir -p /run/php-fpm
#Timezone 
ARG TIMEZONE=Asia/Jakarta
ENV TIMEZONE=$TIMEZONE

#SSH Service
ARG SSH_SERVICE=start
ENV SSH_SERVICE=$SSH_SERVICE
ARG SSH_USER=user
ENV SSH_USER=$SSH_USER
ARG SSH_PASSWORD=password
ENV SSH_PASSWORD=$SSH_PASSWORD

#PHP Variable
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

#Pointing
WORKDIR /var/www/html

ENTRYPOINT ["/config/runner.sh"]
CMD nginx -g 'daemon off;'
