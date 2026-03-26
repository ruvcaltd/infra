# Deployment Gotchas

This file summarizes deployment problems we encountered and the exact fixes applied in this repository.

## 1. GitHub Actions ssh-agent step failure
- Problem: `webfactory/ssh-agent@v0.8.2` (and `@v0.8.1`) failing with invalid version/tag on GitHub runner.
- Fix: pin to a valid existing action version (`webfactory/ssh-agent@v0.9.1`) in `.github/workflows/deploy.yml`.

## 2. Missing target directory on remote host
- Problem: `rsync` failed or created the wrong folder when remote deploy root did not exist.
- Fix: add `mkdir -p /home/deploy/infra` in workflow before `rsync`.

## 3. .env file deleted during rsync
- Problem: `rsync --delete` unintentionally removed `.env` on a deploy target that keeps secrets locally.
- Fix: add `--exclude .env` to `rsync` and keep dev/production vars managed separately.

## 4. Docker image tags not found
- Problem: `bitnami/zookeeper` and `bitnami/kafka` tags used in `docker-compose.yml` were missing or unavailable during `docker compose pull`.
- Fix: switch to official `confluentinc/cp-zookeeper:7.5.0` and `confluentinc/cp-kafka:7.5.0` images and layer paths they support.

## 5. Consistent container name conflict
- Problem: fixed `container_name` in compose can collide with existing containers and block recreate operations.
- Fix: remove `container_name` from service definitions so Compose can manage names and scale safely.

## 6. Non-idempotent compose deploy commands
- Problem: `docker compose up -d` might fail when existing containers exist or are in bad state.
- Fix: add `docker compose down --remove-orphans || true` before `docker compose pull && docker compose up -d`.

## 7. Production env contrast and docs
- Problem: missing documentation for environment variables needed by deploy and compose.
- Fix: update `README.md` with `.env` variable definitions and real expected key names.

---

## Notes
- Ensure `.env` is always provided out-of-band (not in repo) and excluded from synchronization.
- Run one-off validation of the full workflow after each change: `docker compose pull && docker compose up -d` on the remote host.
- If new image version is needed, update both compose and GitHub workflow in the same PR to avoid drift.
