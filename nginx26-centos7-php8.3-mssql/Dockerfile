FROM quay.io/centos/centos:centos7

#Fix Repository
RUN mkdir /etc/yum.repos.d/old
RUN mv /etc/yum.repos.d/CentOS*.repo /etc/yum.repos.d/old/
COPY config/repo/CentOS.repo /etc/yum.repos.d/CentOS.repo
COPY config/repo/epel.repo /etc/yum.repos.d/epel.repo
RUN curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
RUN yum clean all
#RUN yum -y check-update

#Set Repo PHP
RUN yum install -y epel-release \
                   https://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php83
RUN yum -y install sudo \
        curl \
        wget \
        nano \
        htop \
        unzip \
        git

#Install PHP and Nginx
RUN yum -y install https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.26.0-1.el7.ngx.x86_64.rpm
RUN yum -y install php \
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
		   php-devel \
		   php-pear

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
COPY config/www.conf /etc/php-fpm.d/www.conf
#Install Supervisor
RUN yum install -y supervisor
COPY config/supervisord.conf /etc/supervisord.conf

#Install Composer
RUN curl –sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

#Config by Script
ADD config  /config
RUN chmod -R +x /config
RUN mkdir -p /run/php-fpm

#Install mssql Driver
RUN yum install -y unixODBC unixODBC-devel
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
RUN echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini

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

