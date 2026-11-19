SET 4 ONE-STOP AWS KIT
ZIP IS NOT PASSWORD-PROTECTED. The lab service passwords are set to 1234.
Jenkins is intentionally excluded because your instruction is to do Jenkins separately.

IMPORTANT
1. Launch one Ubuntu 24.04 EC2 instance. Recommended for this combined lab: t3.xlarge (4 vCPU, 16 GiB RAM), 30 GB gp3 storage.
2. In the EC2 Security Group, allow:
   TCP 22 from YOUR public IP only
   TCP 8080 from your IP (Tomcat / app)
   TCP 8081 from your IP (WordPress)
   TCP 8082 from your IP (Nagios)
   TCP 30080 from your IP (Kubernetes NodePort, if you use it)
3. Do NOT expose MySQL port 3306 publicly.
4. SSH into the EC2 instance and paste the commands below.

COMMAND 1: Download and extract this kit on EC2
The ZIP is on your computer, so upload it to EC2 with SCP, or extract it locally and copy the folder.
Using the AWS web console:
  1. Open EC2 > Instances > select your Ubuntu instance > Connect > EC2 Instance Connect.
  2. To transfer this ZIP, upload it to an S3 bucket using the S3 web console.
  3. In the S3 object menu, choose Share / Create presigned URL (or use an appropriately permitted object URL).
  4. In the EC2 browser terminal, run:
       sudo apt-get update
       sudo apt-get install -y unzip
       wget -O Set4_OneStop_AWS.zip 'PASTE_PRESIGNED_S3_URL_HERE'
       unzip -o Set4_OneStop_AWS.zip
       cd Set4_OneStop_AWS
  Keep the S3 object private; use a short-lived presigned URL and do not share it.

COMMAND 2: Install everything needed on Ubuntu EC2
  chmod +x scripts/*.sh
  sudo bash scripts/01-install-ec2.sh

COMMAND 3: Run Docker + WordPress + Nagios + Java app
  sudo bash scripts/02-start-docker-labs.sh

COMMAND 4: Run Minikube / Kubernetes exercise
  sudo bash scripts/03-kubernetes-lab.sh

COMMAND 5: Verify everything
  sudo bash scripts/04-verify.sh

DEFAULT LAB CREDENTIALS
WordPress initial setup: create username admin and password 1234 in the browser installer.
Nagios: nagiosadmin / 1234
MySQL root password: 1234
MySQL database: wordpress
MySQL user: wpuser
MySQL password: 1234

BROWSER URLS
WordPress: http://EC2_PUBLIC_IP:8081
Nagios:     http://EC2_PUBLIC_IP:8082
Java app:   http://EC2_PUBLIC_IP:8080

Kubernetes:
The script prints the access command / URL. On a remote EC2 host, use:
  kubectl port-forward service/online-shopping-service 30080:8080 --address 0.0.0.0
Then open http://EC2_PUBLIC_IP:30080

NOTES
- This is an academic demonstration configuration. Password 1234 is deliberately weak. Never use it for real services or production.
- The WordPress exercise is independent of the Java OnlineShoppingApp repository, exactly as the lab sheet states.
- The Java repository may need database/schema configuration. The script builds and deploys its WAR but cannot safely invent application-specific DB settings. If the application expects a local MySQL schema, inspect its source/database SQL and configure it before expecting login/order functions to work.
- Minikube plus Docker, WordPress, Nagios and Tomcat are resource-heavy. If the EC2 instance runs out of memory, stop one service while demonstrating another.
- AWS charges apply while the EC2 instance and storage are allocated. Stop/terminate resources when finished.
