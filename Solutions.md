# Set 4: Online Shopping Application

## Task 1: WordPress + MySQL with Docker
This is a separate WordPress exercise. It does NOT use the OnlineShoppingApp GitHub repository.

```bash
mkdir -p ~/set4/wordpress
cd ~/set4/wordpress
# Copy docker-compose.yml from this pack into this directory
docker compose up -d
docker compose ps
docker compose logs wordpress
docker compose logs db
```
Open `http://EC2_PUBLIC_IP:8081`, finish WordPress setup and publish sample product information. Both containers share `set4-net`; WordPress connects to database host `db`. MySQL data persists in named volume `set4-mysql-data`. Do not run `docker compose down -v` if you want to retain it.

## Task 2: Jenkins
Excluded from this AWS pack as requested. On the separate Jenkins machine, create a Freestyle project for `https://github.com/nikithamoturi/OnlineShoppingApp.git`, configure the required branch and a push/Poll SCM trigger, run `clean test package`, inspect console/test output, demonstrate failed then successful builds, and archive `target/*.war`.

## Task 3: Kubernetes + Minikube on EC2
Install Docker, kubectl and Minikube on Ubuntu EC2. Clone the repo and build the WAR. Confirm that Maven creates a WAR in `target/` and that the app is compatible with Tomcat 9.

```bash
git clone https://github.com/nikithamoturi/OnlineShoppingApp.git
cd OnlineShoppingApp
mvn clean package
docker build -t online-shopping:v1 -f /path/to/app/Dockerfile .
minikube start --driver=docker
minikube image load online-shopping:v1
kubectl apply -f /path/to/kubernetes/deployment.yaml
kubectl get deployments,pods,svc
kubectl scale deployment online-shopping --replicas=5
kubectl get pods
kubectl delete pod POD_NAME
kubectl get pods -w
kubectl port-forward service/online-shopping 8080:80 --address 0.0.0.0
```
Allow inbound TCP 8080 in the EC2 Security Group from your own IP, then visit `http://EC2_PUBLIC_IP:8080`. Deployment begins with 3 replicas, scales to 5, and replaces a deleted pod automatically. Port-forward is suitable for a lab demonstration, not production exposure.

## Task 4: Nagios on Docker
Run `bash run-nagios.sh` from the nagios folder. Dashboard: `http://EC2_PUBLIC_IP:8082`. The included host/service configuration is a starter example. Mount it into the configuration path expected by the selected Nagios image and validate the config before restarting Nagios.

Monitor HTTP on port 8080, MySQL TCP 3306, CPU, memory, disk and uptime. Configure suitable WARNING and CRITICAL thresholds. A TCP check only proves the port accepts connections, not that the full application works.

## Task 5: Direct AWS EC2 deployment
Review `aws/deploy-tomcat.sh`, then run it on Ubuntu EC2. It installs Java, Maven and Tomcat 9, clones the repository, builds the WAR and deploys it as ROOT.war. Verify:
```bash
sudo systemctl status tomcat
curl -I http://localhost:8080/
```
Open `http://EC2_PUBLIC_IP:8080/` and add inbound TCP 8080 to the Security Group. Restrict SSH TCP 22 to your own public IP. Associate an Elastic IP if you need a stable address after stop/start.

## Useful troubleshooting
```bash
docker ps -a
docker logs CONTAINER
kubectl describe pod POD_NAME
kubectl logs POD_NAME
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl rollout undo deployment/online-shopping
sudo journalctl -u tomcat --no-pager -n 100
sudo ss -lntp
```

## Important notes
- Do not mix the WordPress exercise database with the Java shopping application unless the source code explicitly requires it.
- The repository's actual branch, Maven build output, application context path and Servlet API version must be checked.
- If the app uses legacy `javax.servlet`, Tomcat 9 is generally the safer choice; Tomcat 10 uses `jakarta.servlet`.
- Minikube on EC2 is a lab demonstration, not a production Kubernetes architecture.
