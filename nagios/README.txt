Nagios dashboard URL: http://EC2_PUBLIC_IP:8082
Login username: nagiosadmin
Login password: 1234

The dashboard container is launched by docker-compose.yml. The lab sheet also expects custom host/service checks for HTTP, MySQL, CPU, memory, disk and uptime. This kit starts the Nagios dashboard but does not claim those custom checks are configured: the exact plugin paths and configuration layout depend on the selected Nagios image. Verify the image's /opt/nagios/etc/objects configuration inside the running container before adding host/service definitions.

Useful commands:
  docker exec -it set4-nagios bash
  find /opt/nagios/etc -maxdepth 4 -type f
  docker logs --tail 100 set4-nagios

The EC2 host can be monitored as a remote host only after NRPE or an agent/check command is configured. Add an HTTP check once the application URL responds. MySQL should be checked internally on the Docker network, not exposed to the internet.
