#!/bin/bash

chown -R www-data:www-data /var/www/html
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${CERTS_}nginx-selfsigned.key -out ${CERTS_}nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=MA" 
nginx -g "daemon off;"
