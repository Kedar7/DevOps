#!/bin/bash
# Install python, pip, git, run Flask app (simple, non-container)
set -e
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y python3 python3-venv python3-pip git
else
  yum update -y
  yum install -y python3 python3-pip git
fi
cd /opt
if [ ! -d "DevOps" ]; then
  git clone https://github.com/Kedar7/DevOps.git || true
fi
cd DevOps/express_flask_docker/backend
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt
# Run in background (for demo only)
nohup python3 app.py &
