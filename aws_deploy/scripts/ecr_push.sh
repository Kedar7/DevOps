#!/bin/bash
# Helper script to build and push frontend/backend images to ECR
# Usage: ./ecr_push.sh <aws-region> <account-id> <frontend-repo> <backend-repo>
set -e
REGION=${1:-us-east-1}
ACCOUNT=${2:?ACCOUNT_ID required}
FRONT_REPO=${3:-ef_frontend}
BACK_REPO=${4:-ef_backend}

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

# Create repos if not exist
aws ecr describe-repositories --repository-names "$FRONT_REPO" --region $REGION >/dev/null 2>&1 || aws ecr create-repository --repository-name "$FRONT_REPO" --region $REGION
aws ecr describe-repositories --repository-names "$BACK_REPO" --region $REGION >/dev/null 2>&1 || aws ecr create-repository --repository-name "$BACK_REPO" --region $REGION

# Build and push frontend
docker build -t ${FRONT_REPO}:latest ./express_flask_docker/frontend
docker tag ${FRONT_REPO}:latest ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${FRONT_REPO}:latest
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${FRONT_REPO}:latest

# Build and push backend
docker build -t ${BACK_REPO}:latest ./express_flask_docker/backend
docker tag ${BACK_REPO}:latest ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${BACK_REPO}:latest
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${BACK_REPO}:latest

echo "Pushed images to ECR: ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/{${FRONT_REPO},${BACK_REPO}}"
