#!/usr/bin/env bash
# Tambah User
#useradd $SSH_USER --create-home --password "$(openssl passwd -1 "$SSH_PASSWORD")" && echo "$SSH_USER ALL=(ALL:ALL) ALL" >> /etc/sudoers
adduser -h /home/$SSH_USER -s /bin/ash -D $SSH_USER
echo "$SSH_USER:$(openssl passwd -1 "$SSH_PASSWORD")" | chpasswd -e
echo "$SSH_USER ALL=(ALL) ALL" >> /etc/sudoers.d/$SSH_USER

# Timezone (Zona Waktu)
rm -f /etc/localtime;  ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# Ownership
chown -R www-data:www-data /var/www/html

# Supervisord
supervisord -c /etc/supervisord.conf

# PHP CORE
#sed -i "s/post_max_size = .*/post_max_size = $POST_MAX_SIZE/" /etc/php/8.3/fpm/php.ini
#sed -i "s/memory_limit = .*/memory_limit = $MEMORY_LIMIT/" /etc/php/8.3/fpm/php.ini
#sed -i "s/max_input_vars = .*/max_input_vars = $MAX_INPUT_VARS/" /etc/php/8.3/fpm/php.ini
#sed -i "s/upload_max_filesize = .*/upload_max_filesize = $UPLOAD_MAX_FILESIZE/" /etc/php/8.3/fpm/php.ini
#sed -i "s/max_execution_time = .*/max_execution_time = $MAX_EXECUTION_TIME/" /etc/php/8.3/fpm/php.ini
#sed -i "s/max_input_time = .*/max_input_time = $MAX_INPUT_TIME/" /etc/php/8.3/fpm/php.ini

service php-fpm83 start && service sshd $SSH_SERVICE && service nginx start && /bin/bash

chmod 777 /run/php-fpm83/php-fpm.sock

exec "$@"
