
#db_name = Database Name
#db_user = User
#db_pwd = User Password

# echo "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE ;" > db1.sql
# echo "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD' ;" >> db1.sql
# echo "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%' ;" >> db1.sql
# echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD' ;" >> db1.sql
# echo "FLUSH PRIVILEGES;" >> db1.sql

# mysql < db1.sql


# mysqld_safe

service mariadb start
mariadb -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
# Create user if not exists
mariadb -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';"

# Grant privileges to user
mariadb -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';"

# Flush privileges to apply changes
mariadb -e "FLUSH PRIVILEGES;"

#--------------mariadb restart--------------#
# Shutdown mariadb to restart with new config
chmod 775 /run/mysqld/
# mysqladmin -u root -p$MARIADB_ROOT_PASSWORD shutdown
mariadb-admin -u root -p$MARIADB_ROOT_PASSWORD shutdown


# Restart mariadb with new config in the background to keep the container running
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
