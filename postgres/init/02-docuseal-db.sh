#!/bin/bash
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "CREATE DATABASE docuseal;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "CREATE USER documenso_user WITH PASSWORD '$DOCUMENSO_DB_PASSWORD';"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "GRANT ALL PRIVILEGES ON DATABASE docuseal TO documenso_user;"