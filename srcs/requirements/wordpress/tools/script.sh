#!/bin/bash
sleep 5
cd /var/www/html
rm -rf *
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
mkdir -p /var/www/.wp-cli/cache/
chown -R www-data:www-data /var/www/.wp-cli/cache/
chown -R www-data:www-data .
chmod -R 755 .
sudo -u www-data wp core download
sudo -u www-data wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=maria-db
sudo -u www-data wp core install --url=https://$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL
sudo -u www-data wp user create $WP_USER $WP_USER_EMAIL --role=editor --user_pass=$WP_PASS  
php-fpm7.4 -F
