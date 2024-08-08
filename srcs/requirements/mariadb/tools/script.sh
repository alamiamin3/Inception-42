#!/bin/bash

mv /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

service mariadb start

sleep 5

mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

mariadb -e "FLUSH PRIVILEGES;" -p$MYSQL_ROOT_PASSWORD

mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown


mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'