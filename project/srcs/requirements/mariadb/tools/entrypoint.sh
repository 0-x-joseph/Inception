#!/bin/bash
set -eu

DATADIR="/var/lib/mysql"

if [ -d "$DATADIR/$MARIA_DB_NAME" ]; then
  exec "$@"
fi

mariadb-install-db --user=mysql --datadir="$DATADIR"

mariadbd --user=mysql &
PID=$!

until mariadb-admin ping --silent; do
  sleep 1
done

mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$MARIA_DB_NAME\`;
CREATE USER IF NOT EXISTS \`$MARIA_USERNAME\`@'%' IDENTIFIED BY '$MARIA_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MARIA_DB_NAME\`.* TO \`$MARIA_USERNAME\`@'%';

ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$MARIA_ROOT_PASSWORD');
FLUSH PRIVILEGES;
EOF

mariadb-admin -u root -p"$MARIA_ROOT_PASSWORD" shutdown
wait "$PID"

echo "[mariadb] Initialization complete."

exec "$@"
