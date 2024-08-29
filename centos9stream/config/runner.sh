#!/usr/bin/env bash
# Tambah User
useradd $SSH_USER --create-home --password "$(openssl passwd -1 "$SSH_PASSWORD")" && echo "$SSH_USER ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Timezone (Zona Waktu)
rm -f /etc/localtime;  ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# Ownership
chown -R www-data:www-data /var/www/html

# Supervisord
supervisord -c /etc/supervisor/supervisord.conf

# PHP CORE
sed -i "s/post_max_size = .*/post_max_size = $POST_MAX_SIZE/" /etc/php.ini
sed -i "s/memory_limit = .*/memory_limit = $MEMORY_LIMIT/" /etc/php.ini
sed -i "s/max_input_vars = .*/max_input_vars = $MAX_INPUT_VARS/" /etc/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = $UPLOAD_MAX_FILESIZE/" /etc/php.ini
sed -i "s/max_execution_time = .*/max_execution_time = $MAX_EXECUTION_TIME/" /etc/php.ini
sed -i "s/max_input_time = .*/max_input_time = $MAX_INPUT_TIME/" /etc/php.ini

#service php8.3-fpm start && service ssh $SSH_SERVICE
php-fpm

exec "$@"

