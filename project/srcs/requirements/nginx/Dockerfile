FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Remove default site if present (keeps config clean)
RUN rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default || true

# TLS material will live here
RUN mkdir -p /etc/nginx/ssl

# Copy your nginx config(s)
# Expect something like: conf/nginx.conf or conf/default.conf
COPY conf/ /etc/nginx/

# Script will generate cert/key if missing, then exec nginx
COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/script.sh"]

CMD ["nginx", "-g", "daemon off;"]
