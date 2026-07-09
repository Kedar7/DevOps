Minikube Deployment for express_flask_docker

This folder contains manifests and a script to deploy the express (frontend) and Flask (backend) services into a local Minikube Kubernetes cluster.

Overview
- Build and load Docker images into Minikube
- Apply Kubernetes manifests (Deployments + NodePort Services)
- Access frontend via Minikube service and verify backend via /api

Files
- k8s/backend-deployment.yaml
- k8s/backend-service.yaml
- k8s/frontend-deployment.yaml
- k8s/frontend-service.yaml
- build_load.sh  (builds images and applies manifests)

Prerequisites
- minikube installed and running
- kubectl installed
- Docker installed OR use Minikube's built-in builder
- The express_flask_docker folder present at repo root (contains Dockerfiles)

Quick commands
1. Start minikube
   minikube start --driver=docker

2. Build images and deploy (script handles image build and apply)
   chmod +x minikube_deploy/build_load.sh
   ./minikube_deploy/build_load.sh

3. Check resources
   kubectl get pods -n minikube-deploy
   kubectl get svc -n minikube-deploy

4. Open frontend
   minikube service frontend-svc -n minikube-deploy

Notes
- The script uses 'minikube image build' to build images directly into minikube. If your minikube driver doesn't support it, use 'docker build' then 'minikube image load'.
- Take screenshots of: minikube status, kubectl get pods, kubectl get svc, and the opened frontend page to include in your submission.

If any step fails, paste the terminal output here and I'll help troubleshoot.
