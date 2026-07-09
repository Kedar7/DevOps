#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR=$(dirname "$(dirname "$0")")
cd "$ROOT_DIR"

NAMESPACE=minikube-deploy

echo "Checking minikube status..."
minikube status || true

# Build images into minikube to avoid Docker daemon mismatch
echo "Building backend image into minikube..."
minikube image build -t ef_backend:latest -f express_flask_docker/backend/Dockerfile express_flask_docker/backend

echo "Building frontend image into minikube..."
minikube image build -t ef_frontend:latest -f express_flask_docker/frontend/Dockerfile express_flask_docker/frontend

# Create namespace if missing
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || kubectl create namespace "$NAMESPACE"

# Apply manifests
kubectl apply -f minikube_deploy/k8s/backend-deployment.yaml -n "$NAMESPACE"
kubectl apply -f minikube_deploy/k8s/backend-service.yaml -n "$NAMESPACE"

kubectl apply -f minikube_deploy/k8s/frontend-deployment.yaml -n "$NAMESPACE"
kubectl apply -f minikube_deploy/k8s/frontend-service.yaml -n "$NAMESPACE"

echo "Waiting for pods to be ready (up to 60s), showing status:"
kubectl wait --for=condition=ready pod -l app=backend -n "$NAMESPACE" --timeout=60s || true
kubectl wait --for=condition=ready pod -l app=frontend -n "$NAMESPACE" --timeout=60s || true

kubectl get pods,svc -n "$NAMESPACE"

echo "To open the frontend in your browser run:"
echo "minikube service frontend-svc -n $NAMESPACE"
