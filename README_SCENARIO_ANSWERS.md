# Set 4 Scenario Answers

## Docker
1. If MySQL is unavailable, WordPress may show a database connection error; visitors cannot use DB-backed pages.
2. Without a named volume, removing the MySQL container can remove its writable-layer data, causing content loss.
3. Containers on the same user-defined network resolve one another by container/service name; WordPress uses `mysql` as DB host.
4. `docker ps -a`, `docker logs set4-wordpress`, `docker logs set4-mysql`, `docker inspect`, and `docker compose ps`.
5. Use a separate network, database/schema and credentials, named volume, container names, and a different host port.

## Jenkins
Jenkins is intentionally excluded from this AWS kit. Configure the Freestyle job on your college/local Jenkins using the Git URL in the lab sheet, selected branch, `clean test package`, test report publishing, and `target/*.war` artifact archiving.

## Kubernetes
1. A Deployment controller notices a missing pod and creates a replacement to maintain the desired replica count.
2. Deployment declares the desired number of replicas; the controller continuously reconciles actual state.
3. Scaling adds replicas to handle increased concurrent requests and reduce per-pod load.
4. A Service provides a stable virtual endpoint and load-balances traffic across matching ready pods.
5. Use `kubectl rollout undo deployment/online-shopping` to roll back a bad Deployment rollout.

## Nagios
1. CPU, memory and disk checks reveal resource pressure before or during an outage.
2. Investigate the failing check, inspect logs/resources, restore service, and verify the alert returns to OK.
3. An HTTP check tests the web endpoint itself, so it can fail even when EC2 responds to ping/SSH.
4. If Nagios itself fails, monitoring visibility and alerts disappear; monitor it externally or use a second monitoring path.
5. Check network/DNS/connectivity, then Tomcat process/port/logs, then MySQL process/port/logs and DB connectivity from the app container.

## AWS
1. Wrong port, restrictive Security Group/NACL, app not listening on public interface, failed service, wrong URL/context path, or host firewall.
2. SSH from all IPs increases brute-force and unauthorized-access exposure; restrict TCP 22 to the administrator's current public IP.
3. EC2 remains running, but the application endpoint fails until Tomcat is restarted/recovered.
4. Use multiple instances across Availability Zones, an Application Load Balancer, Auto Scaling, health checks, and monitoring.
5. A load balancer distributes requests and health-checks instances; multiple EC2 instances provide capacity and reduce single-instance failure risk.
