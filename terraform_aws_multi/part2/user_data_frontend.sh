#!/bin/bash
# Install node, npm, git, and run express frontend
set -e
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y curl git
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt-get install -y nodejs
else
  yum update -y
  curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
  yum install -y nodejs
fi
cd /opt
if [ ! -d "DevOps" ]; then
  git clone https://github.com/Kedar7/DevOps.git || true
fi
cd DevOps/express_flask_docker/frontend
npm install
nohup node index.js &
