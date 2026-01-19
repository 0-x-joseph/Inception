#!/bin/sh

# 1. Wait for MariaDB to be ready (Optional but recommended)
# sleep 5 

# 2. Check if WordPress is already installed by looking for wp-config.php
if [ ! -f "/var/www/html/wp-config.php" ]; then
    
    echo "WordPress not found. Starting installation..."

    # installing wp-cli
    cd /tmp
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    mkdir -p /var/www/html
    cd /var/www/html

    # Download and Setup
    wp core download --allow-root --locale=en_US
    
    wp config create --allow-root \
        --dbname=${WP_DB_NAME} \
        --dbuser=${WP_DB_USER} \
        --dbpass=${WP_DB_PASSWORD} \
        --dbhost=${WP_DB_HOST}

    wp core install --allow-root \
        --url=${WP_URL} \
        --title=Inception \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    wp user create --allow-root "${WP_USER}" "${WP_EMAIL}" \
        --user_pass="${WP_PASSWORD}" --role=author

    echo "WordPress installation complete."
else
    echo "WordPress already installed. Skipping setup."
fi

# 3. Start PHP-FPM (This must be the LAST command)
exec php-fpm7.4 -F -R
