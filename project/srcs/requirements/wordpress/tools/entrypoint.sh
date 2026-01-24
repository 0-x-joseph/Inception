#!/bin/sh
set -eux

WP_PATH="/var/www/html"

echo "[wp] Waiting for database at host $WP_DB_HOST..."
until mysqladmin ping -h"$WP_DB_HOST"  --silent; do
  sleep 2
done
echo "[wp] Database is ready."

mkdir -p "$WP_PATH"

if  ! wp core is-installed --allow-root --path="$WP_PATH" > /dev/null 2>&1; then
	echo "[wp] Wordpress not installed. Installing..."

	# download
	wp core download \
		--allow-root \
		--locale=en_US \
		--path="$WP_PATH"
    
    
	wp config create \
		--allow-root \
		--dbname="$WP_DB_NAME" \
		--dbuser="$WP_DB_USER" \
		--dbpass="$WP_DB_PASSWORD" \
		--dbhost="$WP_DB_HOST" \
		--path="$WP_PATH"

	wp core install \
		--allow-root \
		--url="$WP_URL" \
		--title=Inception \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--path="$WP_PATH"

	wp user create \
		--allow-root \
		"$WP_USER" "$WP_EMAIL" \
		--user_pass="$WP_PASSWORD" \
		--role=author \
		--path="$WP_PATH"

	chown -R www-data:www-data "$WP_PATH"

	echo "[wp] WordPress installation complete."
else
	echo "[wp] WordPress already installed. Skipping."
fi

exec "$@"
