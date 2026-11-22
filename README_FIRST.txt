SET 4 ONE-STOP AWS KIT
Lab service passwords are set to 1234 as required for the academic exercise.
Jenkins is intentionally excluded because it is performed separately.

TARGET EC2 CONFIGURATION
1. Ubuntu Server 24.04 LTS, t3.large (2 vCPU, 8 GiB RAM), 30 GiB gp3.
2. Create the instance using the AWS EC2 web console.
3. Security Group inbound rules:
   TCP 22 from YOUR public IP only
   TCP 8080 from YOUR public IP (Java app)
   TCP 8081 from YOUR public IP (WordPress)
   TCP 8082 from YOUR public IP (Nagios)
   TCP 30080 from YOUR public IP only when testing Kubernetes
4. Do NOT create a public inbound rule for MySQL port 3306.
5. Use EC2 Instance Connect in the browser. No local SSH client or file download is required.

COMMAND 1: Get the project on EC2
Run these commands in the EC2 Instance Connect browser terminal:

   sudo apt-get update
   sudo apt-get install -y git
   git clone https://github.com/tarangharsola/OnlineShoppingApp.git
   cd OnlineShoppingApp

COMMAND 2: Install dependencies
   sudo bash scripts/01-install-ec2.sh

The installer configures Docker Engine, Docker Compose, Java 17, Maven, Minikube, kubectl and a 2 GiB swap file. Swap is only a safety buffer and is not a replacement for RAM.

COMMAND 3: Start the Docker lab
   sudo bash scripts/02-start-docker-labs.sh

This builds the JSP application WAR and starts MySQL, WordPress, Nagios and Tomcat. Container memory limits are configured for an 8 GiB host.

BROWSER URLS
WordPress: http://EC2_PUBLIC_IP:8081
Nagios:     http://EC2_PUBLIC_IP:8082
Java app:   http://EC2_PUBLIC_IP:8080

Nagios login: nagiosadmin / 1234
WordPress: complete the first-run setup in the browser.
MySQL root password: 1234
MySQL database: wordpress
MySQL user: wpuser
MySQL password: 1234

COMMAND 4: Run the Kubernetes exercise
IMPORTANT: this command stops the Docker Compose stack first to free memory.

   sudo bash scripts/03-kubernetes-lab.sh

Minikube is limited to 2 CPUs and 2 GiB RAM. The Kubernetes deployment applies pod CPU and memory requests/limits and caps the Tomcat heap.

For remote browser access, keep this command running in a terminal:
   kubectl port-forward service/online-shopping-service 30080:8080 --address 0.0.0.0

Then open:
   http://EC2_PUBLIC_IP:30080

Allow TCP 30080 from your IP in the EC2 Security Group only while testing.

COMMAND 5: Verify
   sudo bash scripts/04-verify.sh

SWITCHING BACK TO DOCKER
When the Kubernetes exercise is complete:
   minikube stop
   sudo bash scripts/02-start-docker-labs.sh

RESOURCE RULES FOR 8 GiB EC2
- Do not run the full Docker Compose stack and Minikube simultaneously.
- Compose service memory limits total 4 GiB; the OS, Docker and file cache need additional memory.
- Minikube uses 2 GiB and the Java pods have bounded memory.
- If the host is under pressure, stop unused services and inspect: free -h; docker stats --no-stream.

IMPORTANT APPLICATION LIMITATION
The upstream OnlineShoppingApp is a basic JSP demonstration. Its login and registration forms and product purchase buttons are not connected to a complete authentication, database persistence, cart or checkout backend. This deployment kit builds and deploys the existing WAR; it does not invent missing application features or claim that purchases are functional.

SECURITY AND COST
- Password 1234 is deliberately weak and is only for the academic lab. Never use it for a real or production system.
- Do not expose MySQL port 3306 publicly.
- Restrict all web ports to your own IP in the EC2 Security Group.
- AWS charges apply while EC2 and storage resources are allocated. Stop or terminate resources when finished.
