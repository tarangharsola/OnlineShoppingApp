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

if [ ! -f "$ROOT/pom.xml" ] || [ ! -f "$ROOT/src/main/webapp/index.jsp" ]; then
  echo "Application source is missing. Ensure you cloned the complete fork."
  exit 2
fi

cd "$ROOT"
export MAVEN_OPTS="-Xms128m -Xmx768m"
mvn -B -f "$ROOT/pom.xml" clean package

WAR="$ROOT/target/OnlineShoppingApp.war"
if [ ! -f "$WAR" ]; then
  echo "Maven build completed but $WAR was not found."
  exit 3
fi

cp "$WAR" "$ROOT/app/ROOT.war"
docker compose -f docker/docker-compose.yml config
docker compose -f docker/docker-compose.yml up -d --build
echo
echo "Docker lab started. Wait 60-90 seconds for first-time image pulls and initialization."
docker compose -f docker/docker-compose.yml ps
echo
echo "URLs: WordPress http://EC2_PUBLIC_IP:8081 | Nagios http://EC2_PUBLIC_IP:8082 | Java app http://EC2_PUBLIC_IP:8080"
echo "Nagios login: nagiosadmin / 1234"
