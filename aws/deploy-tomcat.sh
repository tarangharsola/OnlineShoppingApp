#!/usr/bin/env bash
set -euo pipefail
REPO_URL="https://github.com/nikithamoturi/OnlineShoppingApp.git"
APP_DIR="$HOME/OnlineShoppingApp"
sudo apt-get update
sudo apt-get install -y git maven openjdk-17-jdk tomcat9
if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$REPO_URL" "$APP_DIR"
else
  git -C "$APP_DIR" pull
fi
cd "$APP_DIR"
mvn clean package
WAR_FILE="$(find target -maxdepth 1 -type f -name '*.war' | head -n 1)"
if [ -z "$WAR_FILE" ]; then
  echo "No WAR found in target/. Check Maven build output."
  exit 1
fi
sudo systemctl stop tomcat
sudo rm -f /var/lib/tomcat9/webapps/ROOT.war
sudo rm -rf /var/lib/tomcat9/webapps/ROOT
sudo cp "$WAR_FILE" /var/lib/tomcat9/webapps/ROOT.war
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo systemctl --no-pager --full status tomcat
