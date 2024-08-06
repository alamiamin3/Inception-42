#!/bin/bash
sleep 5
mv ./default.conf /etc/nginx/conf.d/
chown -R www-data:www-data /var/www/html
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/certs/nginx-selfsigned.key -out /etc/nginx/ssl/certs/nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=MA" 
nginx -g "daemon off;"