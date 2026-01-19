#!/bin/bash
set -e

: "${DOMAIN_NAME:?Missing DOMAIN_NAME}"

# Prefer Compose/Docker secrets (mounted by default at /run/secrets/<name>) [web:78]
CRT_SECRET="/run/secrets/server_crt"
KEY_SECRET="/run/secrets/server_key"

# Final paths nginx will use
CRT="/etc/nginx/ssl/inception.crt"
KEY="/etc/nginx/ssl/inception.key"

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

exec "$@"
