#!/bin/bash
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "CREATE DATABASE docuseal;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "CREATE USER documenso_user WITH PASSWORD '$DOCUMENSO_DB_PASSWORD';"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "ALTER USER documenso_user CREATEDB;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "ALTER USER documenso_user CREATEROLE;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "ALTER USER documenso_user REPLICATION;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "ALTER DATABASE docuseal OWNER TO documenso_user;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d docuseal -c "GRANT ALL ON SCHEMA public TO documenso_user;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d docuseal -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO documenso_user;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d docuseal -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO documenso_user;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d docuseal -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO documenso_user;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d docuseal -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO documenso_user;"