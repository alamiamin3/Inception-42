FROM debian:bullseye

RUN mkdir -p /etc/nginx/ssl/certs/

RUN apt-get update && apt-get install -y nginx && apt install openssl -y

COPY ./conf/default.conf /etc/nginx/conf.d/
COPY ./tools /tools

WORKDIR /tools

RUN chmod +x script.sh

CMD ./script.sh