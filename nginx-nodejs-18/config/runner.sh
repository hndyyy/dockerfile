# Tambah User
useradd $SSH_USER --create-home --password "$(openssl passwd -1 "$SSH_PASSWORD")" && echo "$SSH_USER ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Timezone (Zona Waktu)
rm -f /etc/localtime;  ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# Ownership
chown -R www-data:www-data /var/www/html

service nginx restart && service ssh $SSH_SERVICE
