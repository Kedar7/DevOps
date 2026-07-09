#!/usr/bin/env bash
set -euo pipefail
REGION=${1:-us-east-1}
ACCOUNT=${2:?AWS_ACCOUNT_ID required}

# Build tags
FRONT_TAG=ef_frontend:latest
BACK_TAG=ef_backend:latest

# Build locally
docker build -t $FRONT_TAG ./express_flask_docker/frontend
docker build -t $BACK_TAG ./express_flask_docker/backend

# Login and push to ECR (requires awscli configured)
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
aws ecr create-repository --repository-name ef_frontend --region $REGION || true
aws ecr create-repository --repository-name ef_backend --region $REGION || true

docker tag $FRONT_TAG ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ef_frontend:latest
docker tag $BACK_TAG ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ef_backend:latest

docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ef_frontend:latest
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ef_backend:latest

echo "Pushed images to ECR"
