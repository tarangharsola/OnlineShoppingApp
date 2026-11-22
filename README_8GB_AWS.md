# AWS 8 GB Deployment Guide

This guide targets Ubuntu 24.04 on an EC2 instance with 8 GiB RAM, such as a t3.large, and 30 GiB gp3 storage.

## Recommended security group

- TCP 22: your public IP only
- TCP 8080, 8081, 8082: your public IP only while using the Docker lab
- TCP 30080: your public IP only while testing Kubernetes
- Do not expose TCP 3306 publicly

## Deployment sequence

Use EC2 Instance Connect in the AWS web console. No local SSH client or local project download is required.

```bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/tarangharsola/OnlineShoppingApp.git
cd OnlineShoppingApp
sudo bash scripts/01-install-ec2.sh
sudo bash scripts/02-start-docker-labs.sh
```

The installer installs Java 17, Maven, Docker Engine, Docker Compose, Minikube and kubectl. It also configures a 2 GiB swap file as an emergency buffer.

## Docker lab

The Compose configuration caps MySQL at 1536 MiB, WordPress at 768 MiB, Nagios at 768 MiB and Tomcat at 1024 MiB.

- WordPress: http://EC2_PUBLIC_IP:8081
- Nagios: http://EC2_PUBLIC_IP:8082
- Java application: http://EC2_PUBLIC_IP:8080

Nagios credentials: `nagiosadmin / 1234`. Complete WordPress's first-run setup in the browser.

## Kubernetes lab

Run:

```bash
sudo bash scripts/03-kubernetes-lab.sh
```

This stops Docker Compose before starting Minikube with 2 CPUs and 2048 MiB RAM. The Kubernetes pods have explicit CPU and memory requests/limits and a bounded Tomcat heap. The exercise scales the deployment from three to five replicas.

For remote browser access, keep this command running:

```bash
kubectl port-forward service/online-shopping-service 30080:8080 --address 0.0.0.0
```

Then open http://EC2_PUBLIC_IP:30080. Allow TCP 30080 from your IP only while testing.

When finished, stop Minikube:

```bash
minikube stop
```

To return to the Docker lab, run `sudo bash scripts/02-start-docker-labs.sh`.

## Verification

```bash
sudo bash scripts/04-verify.sh
free -h
docker stats --no-stream
```

## Application limitation

The upstream application is a basic JSP demonstration. Login, registration, cart and checkout are not backed by a complete authentication or persistence implementation. The deployment scripts build and deploy the existing WAR; they do not make missing application functionality operational.

## Lab security

The password `1234` is intentionally weak and suitable only for this academic exercise. Never use it in production. Do not expose MySQL port 3306 publicly, and restrict all web ports to your own IP. AWS charges continue while resources remain allocated.
