#!/bin/bash
cd /var/www/html
rm -rf *
mv /tools/www.conf /etc/php/7.4/fpm/pool.d/
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chown -R www-data:www-data .
chmod 777 .
wp core download --allow-root
wp config create --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$MARIADB_USER_PASSWORD --dbhost=maria-db --allow-root
wp core install --url=https://127.0.0.1 --title="Inception Project" --admin_user= --admin_password=wpcli --admin_email=info@wp-cli.org --allow-root
php-fpm7.4 -F