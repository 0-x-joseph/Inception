#!/bin/bash
# -e: exits with non zero if any line failed
# -u: exit with non zero if variables are unset
# -x: trace execution of each line
set -eux

# Docker Compose secrets mounted by default at /run/secrets/<name>
CRT_SECRET="/run/secrets/server_crt"
KEY_SECRET="/run/secrets/server_key"

# Final paths nginx will use
CRT="/etc/nginx/ssl/inception.crt"
KEY="/etc/nginx/ssl/inception.key"


# Remove default site if present
rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default || true

# TLS material will live here
mkdir -p /etc/nginx/ssl

# If secrets exist, copy them into the expected nginx path with strict perms
if [ -f "$CRT_SECRET" ] && [ -f "$KEY_SECRET" ]; then
  cp "$CRT_SECRET" "$CRT"
  cp "$KEY_SECRET" "$KEY"
  chmod 644 "$CRT"
  chmod 600 "$KEY"
else
  echo "[nginx] ERROR: No certificate found."
  echo "[nginx] Provide either:"
  echo "  - secrets: /run/secrets/server_crt and /run/secrets/server_key, or"
  echo "  - bind mounts: /etc/nginx/ssl/server.crt and /etc/nginx/ssl/server.key"
  exit 1
fi

exec nginx -g 'daemon off;'
