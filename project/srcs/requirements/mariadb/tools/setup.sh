#!/bin/bash

if [ -d "/var/lib/mysql/mysql" ]; then
  exec mariadbd --user=mysql --datadir=/var/lib/mysql
fi

mariadb-install-db --user=mysql --datadir=/var/lib/mysql

mariadbd --user=mysql &
PID=$!

until mariadb-admin ping --silent; do
  echo "Waiting for MariaDB..."
  sleep 1
done

mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MARIA_DB_NAME}\`;
CREATE USER IF NOT EXISTS \`${MARIA_USERNAME}\`@'%' IDENTIFIED BY '${MARIA_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIA_DB_NAME}\`.* TO \`${MARIA_USERNAME}\`@'%';

-- This line is critical for Bullseye: it fixes the 'Access Denied' issue
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MARIA_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
EOF

mariadb-admin -u root -p"${MARIA_ROOT_PASSWORD}" shutdown

exec mysqld_safe
