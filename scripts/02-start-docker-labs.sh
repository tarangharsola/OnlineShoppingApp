#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run with sudo."
  exit 1
fi

if command -v minikube >/dev/null 2>&1 && minikube status >/dev/null 2>&1; then
  echo "Stopping Minikube to keep memory available for Docker services..."
  minikube stop
fi

mkdir -p app/build
if [ ! -d app/source/.git ]; then
  git clone https://github.com/nikithamoturi/OnlineShoppingApp.git app/source
else
  git -C app/source pull --ff-only
fi

cd app/source
mvn -B clean package
WAR="$(find target -maxdepth 1 -type f -name '*.war' | head -n 1)"
if [ -z "$WAR" ]; then
  echo "Maven build completed but no WAR was found in target/."
  exit 2
fi
cp "$WAR" "$ROOT/app/ROOT.war"

cd "$ROOT"
docker compose -f docker/docker-compose.yml config
docker compose -f docker/docker-compose.yml up -d --build
echo
echo "Docker lab started. Wait 60-90 seconds for first-time image pulls and initialization."
docker compose -f docker/docker-compose.yml ps
echo
echo "URLs: WordPress http://EC2_PUBLIC_IP:8081 | Nagios http://EC2_PUBLIC_IP:8082 | Java app http://EC2_PUBLIC_IP:8080"
echo "Nagios login: nagiosadmin / 1234"
