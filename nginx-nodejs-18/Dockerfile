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
# Install NGINX
RUN apt-get install -y nginx
## Konfigurasi NGINX
RUN mkdir /etc/nginx/ssl/
COPY config/nginx/limiter.conf /etc/nginx/conf.d/
COPY config/nginx/default /etc/nginx/sites-enabled/
# Install Nodejs 18 and NPM
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
RUN apt-get install nodejs -y
#RUN npm install -g npm@latest
RUN npm install --global yarn
# Install Supervisord
#RUN apt-get install -y supervisor
#COPY config/supervisord.conf /etc/supervisor
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
# Pointing
WORKDIR /var/www/html
#ENTRYPOINT /config/runner.sh && /bin/bash
RUN chown -R www-data:www-data /var/www/html
CMD nginx -g 'daemon off;'
