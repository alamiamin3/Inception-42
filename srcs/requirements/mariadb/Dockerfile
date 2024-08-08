FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server 

COPY ./tools /tools
COPY ./conf /conf

WORKDIR /tools


RUN chmod +x script.sh

CMD ./script.sh