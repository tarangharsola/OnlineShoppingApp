#!/usr/bin/env bash
set -euo pipefail
echo "=== Docker containers ==="
docker ps -a
echo
echo "=== Docker compose status ==="
docker compose -f "$(dirname "$0")/../docker/docker-compose.yml" ps
echo
echo "=== Recent logs ==="
docker logs --tail 30 set4-wordpress 2>&1 || true
docker logs --tail 30 set4-mysql 2>&1 || true
docker logs --tail 30 set4-nagios 2>&1 || true
docker logs --tail 30 set4-shopping-app 2>&1 || true
echo
echo "=== Kubernetes ==="
kubectl get nodes,deployments,pods,services 2>&1 || true
