#!/usr/bin/env bash
# Script to be invoked by Jenkins to deploy Flask app on the EC2 instance
set -e
cd /opt/DevOps/express_flask_docker/backend
git pull origin main || true
. venv/bin/activate
pip install -r requirements.txt
# Restart Flask process - using nohup in this demo; replace with systemd/gunicorn for production
pkill -f "python3 app.py" || true
nohup python3 app.py &>/opt/flask.log &
echo "Flask deployed"
