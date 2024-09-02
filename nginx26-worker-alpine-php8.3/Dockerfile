FROM node:22.2.0-alpine3.20
ENV DEBIAN_FRONTEND=noninteractive

# Install Tools
RUN apk update
RUN apk add --no-cache libxml2
RUN apk update && apk add --no-cache sudo \
        curl \
        wget \
        nano \
        htop \
        unzip \
        git \
        mysql-client \
        openssh-server \
        openrc \
        openssl \
        bash
#Install Nginx
RUN apk update
RUN openrc
RUN touch /run/openrc/softlevel
RUN apk add --no-cache nginx=1.26.2-r0
#Install PHP 8.3
RUN apk add --no-cache --repository=http://foobar.turbo.net.id/alpine/v3.19/main --repository=http://foobar.turbo.net.id/alpine/v3.19/community \
        php83-fpm \
        php83-curl \
        php83-gmp \
        php83-pdo_mysql \
        php83-common \
        php83-cli \
        php83-gd \
        php83-opcache \
        php83-pecl-imagick \
        php83-mbstring \
        php83-xml \
        php83-zip \
        php83-redis \
        php83-gettext \
        php83-ctype \
        php83-tokenizer \
        php83-mysqli \
        php83-mysqlnd \
        php83-pdo \
        php83-pgsql \
        php83-phar \
	php83
# Instal Composer
RUN curl -sS https://getcomposer.org/installer | php83 && \
    mv composer.phar /usr/local/bin/composer
# Konfiguras
RUN mkdir /etc/nginx/ssl/
RUN mkdir /var/www/html
RUN mkdir /var/www/html/prod/
RUN mkdir /var/www/html/dev/
RUN echo "<?php phpinfo();?>" >> /var/www/html/prod/index.php
COPY config/nginx/php.default.conf /etc/nginx/php.conf.d/
#COPY config/nginx/limiter.conf /etc/nginx/conf.d/
COPY config/nginx/default /etc/nginx/http.d/default.conf
COPY config/www.conf /etc/php83/php-fpm.d/
# Install Supervisor
RUN apk add --no-cache supervisor
# Config by Script
ADD config  /config
RUN chmod -R +x /config
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
# Wokrdir
WORKDIR /var/www/html
ENTRYPOINT ["/config/runner.sh"]
CMD nginx -g 'daemon off;'
