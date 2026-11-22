# AWS 8 GB Deployment Guide

This guide targets an Ubuntu 24.04 EC2 instance with 8 GiB RAM (for example, a t3.large) and 30 GiB gp3 storage.

## Resource strategy

Run the Docker Compose lab and the Kubernetes lab in separate stages. Do not run the full Compose stack and Minikube simultaneously on an 8 GiB host.

- Keep SSH (22) restricted to your own public IP.
- Restrict application ports (8080, 8081, 8082, 30080) to your own IP while testing.
- Do not expose MySQL (3306) to the public internet.
- Use a 2 GiB swap file only as an emergency buffer; swap is not a substitute for RAM.
- Stop the Compose stack before starting Minikube, and stop Minikube before restarting the Compose stack.

## Stage 1: Docker Compose

From the repository root:

```bash
docker compose -f docker/docker-compose.yml config
docker compose -f docker/docker-compose.yml up -d
docker compose -f docker/docker-compose.yml ps
docker compose -f docker/docker-compose.yml logs --tail=100
```

To stop the stack before Kubernetes:

```bash
docker compose -f docker/docker-compose.yml down
```

## Stage 2: Kubernetes with Minikube

Use a constrained Minikube profile:

```bash
minikube start --driver=docker --cpus=2 --memory=2048
```

Build the application image and deploy the manifests using the repository's Kubernetes lab script. Verify resources before exposing the NodePort service:

```bash
kubectl get nodes
kubectl get deployments,pods,services
kubectl rollout status deployment/online-shopping
```

Stop Kubernetes when finished:

```bash
minikube stop
```

## Important application limitation

The upstream OnlineShoppingApp currently provides a basic JSP demonstration. Its login and registration forms and product purchase buttons are not connected to a complete authentication, persistence, cart, or checkout backend. Deployment infrastructure alone does not create those missing application features. Treat this as a demo until those features are implemented and tested.

## Troubleshooting

```bash
free -h
df -h
docker stats --no-stream
docker compose -f docker/docker-compose.yml ps
kubectl get pods -A
```

If memory pressure occurs, stop unused services and confirm that Docker Compose and Minikube are not running together.
