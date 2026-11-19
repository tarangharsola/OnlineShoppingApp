#!/usr/bin/env bash
set -euo pipefail
docker pull jasonrivers/nagios:latest
docker run -d --name set4-nagios --restart unless-stopped -p 8082:80 \
  -v nagios_etc:/opt/nagios/etc -v nagios_var:/opt/nagios/var \
  jasonrivers/nagios:latest
docker ps --filter name=set4-nagios
