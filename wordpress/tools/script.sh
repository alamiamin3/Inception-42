#!/bin/bash

mv www.conf /etc/php/7.4/fpm/pool.d/
cd /var/www/html
rm -rf * 
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chmod 777 .
tail -f
# wp core download --allow-root
# wp config create --dbname=db --dbuser=root --dbpass=example --dbhost=maria-db --allow-root
# wp core install --url=https://localhost:443 --title="WP-CLI" --admin_user=wpcli --admin_password=wpcli --admin_email=info@wp-cli.org --allow-root
# php-fpm7.4 -F