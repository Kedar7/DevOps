#!/usr/bin/env bash
# Script to be invoked by Jenkins to deploy Express app on the EC2 instance
set -e
cd /opt/DevOps/express_flask_docker/frontend
git pull origin main || true
npm install
# Restart via pm2
pm2 restart express-frontend || pm2 start index.js --name express-frontend
pm2 save
echo "Express deployed"
