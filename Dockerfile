# InvoiceShelf for Railway.
# The official image, pinned by version and digest. To update, change both,
# add a CHANGELOG.md entry and test on a scratch project before merging.
FROM invoiceshelf/invoiceshelf:2.4.7@sha256:599dc6aa9d7303c9ae0d099397817c7f6002cd6f7af099bc90511d5eae4e9cd2

# The wrapper entrypoint starts as root only to give the Railway volume on
# /var/www/html/storage to www-data, then runs the official entrypoint as
# www-data, the image's normal user.
USER root

# Railway's Postgres can take a little longer than 30 s on a first deploy.
ENV AUTORUN_LARAVEL_MIGRATION_TIMEOUT=120

COPY --chmod=755 railway/railway-entrypoint.sh /usr/local/bin/railway-entrypoint
COPY --chmod=755 railway/60-railway-first-boot.sh /etc/entrypoint.d/60-railway-first-boot.sh
COPY --chmod=644 railway/first-boot.php /usr/local/share/invoiceshelf-railway-first-boot.php

ENTRYPOINT ["railway-entrypoint"]
CMD ["/init"]
