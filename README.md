# Linux Server Infrastructure as Code (Docker Compose)

This repository sets up infrastructure services on a single Linux server using Docker Compose:

- Traefik (reverse proxy, TLS, Docker provider)
- SQL Server (MSSQL)
- PostgreSQL
- Zookeeper + Kafka
- Redis

## Preconditions

- Linux server with Docker + Docker Compose installed
- Derived user has permission to run Docker
- ports 80, 443, 8080, 1433, 5432, 2181, 9092, 6379 available

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

6. Traefik dashboard:

- http://<server-ip>:8080

## Volumes

Data is persisted via named volumes by Docker Compose:

- `mssql_data`
- `postgres_data`
- `zookeeper_data`
- `kafka_data`
- `redis_data`

## Connect from other containers

All app containers on the same Docker network can refer to services by name:

- `mssql:1433`
- `postgres:5432`
- `kafka:9092`
- `redis:6379`

## Production hardening

- Rotate credentials
- Use external secret management (Vault/Key Vault)
- Lock `acme.json` permissions
- Secure network and firewall policies
