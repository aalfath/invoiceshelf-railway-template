[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/invoiceshelf-1?utm_medium=integration&utm_source=button&utm_campaign=invoiceshelf)

# InvoiceShelf on Railway

A Railway template for [InvoiceShelf](https://github.com/InvoiceShelf/InvoiceShelf), the open-source invoicing app for freelancers and small businesses: invoices, estimates, recurring invoices, payments, expenses and a customer portal.

- **Version:** InvoiceShelf 2.4.8, from the official image `invoiceshelf/invoiceshelf:2.4.8`, pinned by digest in the [`Dockerfile`](Dockerfile).
- **Services:** `InvoiceShelf` (built from this repo, public) and Railway's `Postgres`.
- **Storage:** a volume on `/var/www/html/storage` keeps uploads, company logos, PDF templates and logs. Business data lives in Postgres.

## First start

Open the public URL. The setup wizard opens at **Verify domain**: the database is already set up. Confirm the domain, choose a mail driver (or skip with "Log" and set mail up later), then create **your** admin account, your company and its preferences.

Finish the wizard right after deploying: until it's done, whoever opens the URL first can complete it. No default login exists: the template replaces the seeded `admin@invoiceshelf.com` password with a random one nobody knows.

## Variables

| Variable | Value | Notes |
|---|---|---|
| `PORT` | `8080` | nginx listens here |
| `APP_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | change it if you add a custom domain |
| `SANCTUM_STATEFUL_DOMAINS` | `${{RAILWAY_PUBLIC_DOMAIN}}` | domain the browser app logs in from |
| `SESSION_DOMAIN` | `${{RAILWAY_PUBLIC_DOMAIN}}` | session cookie domain |
| `APP_KEY` | `${{secret(32)}}` | encryption key, generated once. Don't change it |
| `DB_CONNECTION` | `pgsql` | |
| `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` | references to `Postgres` | private network |

Optional: `APP_TIMEZONE`, `MAIL_*` (SMTP and other drivers; values set here survive redeploys, while the in-app mail settings are kept only until the next redeploy), `RAILWAY_FIRST_BOOT=false` to turn off the first-boot setup below.

## What this repo adds to the official image

- `railway/railway-entrypoint.sh` starts as root only to give the Railway volume to `www-data` (uid 82) and to let it write to the log pipes, then runs the official entrypoint as `www-data`. It also points nginx at `$PORT`.
- `railway/60-railway-first-boot.sh` and `railway/first-boot.php` run after the image's migrations. On an empty database they seed it, replace the seeded admin's public password with a random one, and start the wizard after its database step. They do nothing once a user exists.

The image runs Laravel's scheduler itself (recurring invoices, overdue flags). Health check: `/healthcheck`.

## Updates

Each change here is a pinned version bump with a [`CHANGELOG.md`](CHANGELOG.md) entry. When it's merged to `main`, Railway shows "update available" on projects deployed from this template, and you choose when to apply it. Migrations run on start. Back up the Postgres database before a major version (3.x).

## License

The wrapper files in this repo are MIT. InvoiceShelf itself is AGPL-3.0.
