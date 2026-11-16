#!/bin/sh
# Runs after the image's own setup (00-setup.sh) and Laravel automations
# (50-laravel-automations.sh, which run the migrations).
# On a fresh database it seeds InvoiceShelf and moves the setup wizard past
# its database step, because the database is already configured through
# Railway variables. Set RAILWAY_FIRST_BOOT=false to skip it.
set -e
if [ "${RAILWAY_FIRST_BOOT:-true}" != "true" ]; then
    exit 0
fi
cd /var/www/html
php /usr/local/share/invoiceshelf-railway-first-boot.php
