FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    tar \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-intl \
    php-mbstring \
    php-soap \
    php-xml \
    php-zip \
		mariadb-client \
 && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|^listen = .*|listen = 9000|g' /etc/php/*/fpm/pool.d/www.conf \
 && mkdir -p /run/php

WORKDIR /var/www/html

COPY ./tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/script.sh"]
