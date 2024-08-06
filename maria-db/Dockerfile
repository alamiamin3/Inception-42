FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server 


COPY ./tools /tools

WORKDIR /tools
# COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# COPY ./tools/init.sql /etc/mysql/init.sql
# RUN chmod +x /etc/mysql/mariadb.conf.d/
# RUN mkdir /run/mysqld 
# RUN chmod +x /run/mysqld
# RUN chmod +x /etc/mysql/init.sql
RUN chmod +x script.sh
CMD ./script.sh