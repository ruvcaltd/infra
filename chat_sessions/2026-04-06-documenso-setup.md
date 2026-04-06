# Chat Session Summary — Documenso Setup

## Date
- 2026-04-06

## Summary
This session documented getting Documenso running in the `infrastructure` Docker Compose stack and resolving email/signing issues.

## Key actions
- Verified `docker-compose.yml` and `.env` for Documenso service configuration.
- Confirmed SMTP environment variables were present and wired into Documenso.
- Removed unneeded `NEXT_PRIVATE_SMTP_SECURE` from `docker-compose.yml` because it was not required.
- Added local signing certificate support by mounting `./certs/documenso.p12` into the Documenso container.
- Kept `NEXT_PRIVATE_SIGNING_PASSPHRASE=` empty because the .p12 file is generated with an empty password.
- Removed redundant `NEXT_PRIVATE_SIGNING_LOCAL_FILE_CONTENTS` setting.
- Documented the need to generate a `.p12` certificate on the VPS and mount it into the container.
- Confirmed that the Documenso service was configured to use local signing transport and SMTP for email.

## File changes
- `docker-compose.yml`
  - Added Documenso signing certificate mount and signing env vars.
  - Added Documenso SMTP env vars.
  - Removed unnecessary `NEXT_PRIVATE_SIGNING_LOCAL_FILE_CONTENTS` and `NEXT_PRIVATE_SMTP_SECURE`.

- `.env`
  - Added Documenso SMTP settings for Brevo.
  - Added Documenso encryption keys.
  - Preserved `POSTGRES_PASSWORD_URLENCODED` for Postgres connection.

## Deployment notes
- On the VPS, create the certs folder and generate `certs/documenso.p12` with OpenSSL.
- Restart Documenso after updating the cert and environment using `docker compose up -d docuseal`.
- Verify sender domain authentication in Brevo if confirmation emails do not arrive.

## Resetting the Documenso database
docker-compose stop docuseal
docker-compose exec postgres psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'docuseal' AND pid <> pg_backend_pid();"
docker-compose exec postgres psql -U postgres -c "DROP DATABASE IF EXISTS docuseal;"
docker-compose exec postgres psql -U postgres -c "CREATE DATABASE docuseal;"
docker-compose up -d docuseal

## Certificate expiration guidance
- When the signing certificate expires, generate a new PKCS#12 certificate at `./certs/documenso.p12` on the VPS.
- Use OpenSSL to create a new cert and bundle it into `.p12`.
- Replace the old `certs/documenso.p12` file and restart Documenso: `docker compose up -d docuseal`
- If using a CA-signed cert, keep the file path the same and update the certificate bundle accordingly.

## Current status
- Documenso is configured with a local signing certificate path and SMTP email settings.
- The setup is now ready to run with a valid `certs/documenso.p12` file and appropriate Brevo sender verification.
