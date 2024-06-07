FROM debian:bullseye

RUN mkdir -p /etc/nginx/ssl/certs/

RUN apt-get update && apt-get install -y nginx && apt install openssl -y


COPY tools/default.conf /etc/nginx/conf.d/
COPY tools/index.php /var/www/html/



# ENTRYPOINT  ["nginx" ,"-g", "daemon off;"]
CMD openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/certs/nginx-selfsigned.key -out /etc/nginx/ssl/certs/nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=MA"  && nginx -g "daemon off;"