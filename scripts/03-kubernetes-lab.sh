#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [ "$(id -u)" -ne 0 ]; then echo "Run with sudo."; exit 1; fi
cd "$ROOT"
if [ ! -f app/ROOT.war ]; then
  echo "app/ROOT.war not found. Run scripts/02-start-docker-labs.sh first."
  exit 2
fi
minikube start --driver=docker --cpus=2 --memory=4096
eval "$(minikube docker-env)"
docker build -t online-shopping:v1 "$ROOT/app"
kubectl apply -f "$ROOT/kubernetes/deployment.yaml"
kubectl rollout status deployment/online-shopping
kubectl get deployments,pods,services
echo
echo "Scale from 3 to 5:"
kubectl scale deployment online-shopping --replicas=5
kubectl rollout status deployment/online-shopping
kubectl get pods -o wide
echo
echo "Pod recreation demonstration:"
POD="$(kubectl get pods -l app=online-shopping -o jsonpath='{.items[0].metadata.name}')"
kubectl delete pod "$POD"
sleep 8
kubectl get pods -l app=online-shopping
echo
echo "For browser access from outside EC2, keep this command running in a terminal:"
echo "kubectl port-forward service/online-shopping-service 30080:8080 --address 0.0.0.0"
echo "Then open http://EC2_PUBLIC_IP:30080 (allow TCP 30080 from your IP in the EC2 Security Group)."
