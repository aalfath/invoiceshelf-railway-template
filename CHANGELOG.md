# Changelog

## 2.4.8 (2026-11-23)

- Breaking changes: none. No new variables and no database migrations.
- Security release: two fixes for installs with more than one company (cross-company role use, exchange-rate update scope), plus a fix to the amount due after a payment is deleted. See the [2.4.8 release notes](https://github.com/InvoiceShelf/InvoiceShelf/releases/tag/2.4.8).
- InvoiceShelf 2.4.7 → **2.4.8** (`invoiceshelf/invoiceshelf:2.4.8@sha256:12b0c62ba1e67b586c9888fcee39385c1989f13f1347afb98aa0b5215025852c`).
- Tested on Railway before merging: the published template was deployed, data was written, the service was switched to this version, and the data and login were still there.

## Unreleased

- README: Deploy on Railway button for the published template (`invoiceshelf-1`). No change to the image or the app.

## 2.4.7 (2026-11-16)

First release of this template.

- InvoiceShelf 2.4.7 (`invoiceshelf/invoiceshelf:2.4.7@sha256:599dc6aa9d7303c9ae0d099397817c7f6002cd6f7af099bc90511d5eae4e9cd2`), PHP 8.4.27.
- Railway Postgres, storage volume on `/var/www/html/storage`.
- First boot seeds the database, removes the seeded default password and starts the setup wizard at its domain step.
