# Linux Server Infrastructure as Code (Docker Compose)

This repository sets up infrastructure services on a single Linux server using Docker Compose:

- Traefik (reverse proxy, TLS, Docker provider)
- SQL Server (MSSQL)
- PostgreSQL
- Zookeeper + Kafka
- Redis
- Portainer (container management)
- N8N (workflow automation)
- Documenso (document signing)

## Preconditions

- Linux server with Docker + Docker Compose installed
- Derived user has permission to run Docker
- ports 80, 443, 8080, 1433, 5432, 2181, 9092, 6379, 9000, 5678 available

## Usage

1. Clone repo on server
2. Edit `.env` secrets
3. Create `acme.json` for Traefik:

```bash
mkdir -p traefik
touch traefik/acme.json
chmod 600 traefik/acme.json
```

4. Start services:

```bash
docker compose up -d
```

5. Check status:

```bash
docker compose ps
```

6. Access services:
   - Traefik dashboard: http://<server-ip>:8080
   - Portainer: https://portainer.<domain>
   - N8N: https://n8n.<domain>
   - Documenso: https://sign.<domain>

## Volumes

Data is persisted via named volumes by Docker Compose:

- `mssql_data`
- `postgres_data`
- `zookeeper_data`
- `kafka_data`
- `redis_data`
- `portainer_data`
- `n8n_data`
- `docuseal_data`

## Connect from other containers

All app containers on the same Docker network can refer to services by name:

- `mssql:1433`
- `postgres:5432`
- `kafka:9092`
- `redis:6379`

## Required environment variables

Set these variables in `.env` and in GitHub Secrets for deployment workflows:

- `VPS_HOST` (host or IP address of your VPS)
- `VPS_USER` (SSH username)
- `VPS_SSH_PORT` (SSH port, e.g., `22`)
- `VPS_PATH` (remote path to deploy code)
- `VPS_SSH_PRIVATE_KEY` (private key for SSH auth)

Optional service-specific variables (already managed in `docker-compose.yml` / `.env` as needed):

- `MSSQL_SA_PASSWORD`
- `POSTGRES_PASSWORD`
- `POSTGRES_USER`
- `POSTGRES_DB`
- `REDIS_PASSWORD`

## Production hardening

- Rotate credentials
- Use external secret management (Vault/Key Vault)
- Lock `acme.json` permissions
- Secure network and firewall policies
