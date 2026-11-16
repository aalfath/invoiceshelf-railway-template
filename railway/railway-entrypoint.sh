#!/bin/sh
# Railway wrapper around the official InvoiceShelf entrypoint.
set -e

# Railway routes the public domain to $PORT. nginx in the image listens on
# NGINX_HTTP_PORT (8080 by default).
export NGINX_HTTP_PORT="${PORT:-${NGINX_HTTP_PORT:-8080}}"

STORAGE=/var/www/html/storage

if [ "$(id -u)" = "0" ]; then
    # A new Railway volume is empty and owned by root. Recreate the folders the
    # image ships in storage/ and hand everything to www-data (uid 82).
    mkdir -p \
        "$STORAGE/app/public" \
        "$STORAGE/app/templates/pdf" \
        "$STORAGE/fonts" \
        "$STORAGE/framework/cache/data" \
        "$STORAGE/framework/sessions" \
        "$STORAGE/framework/views" \
        "$STORAGE/logs"
    find "$STORAGE" \( ! -user www-data -o ! -group www-data \) -exec chown www-data:www-data {} +
    # nginx and PHP-FPM log to /proc/self/fd/1 and 2. Those pipes belong to
    # root, so www-data couldn't reopen them after the switch below.
    # No 2>/dev/null here: it would point fd 2 at /dev/null during the chown.
    chown www-data:www-data /proc/self/fd/1 /proc/self/fd/2 || true
    export HOME=/home/www-data
    exec /command/s6-setuidgid www-data docker-php-serversideup-entrypoint "$@"
fi

exec docker-php-serversideup-entrypoint "$@"
