#!/bin/bash
# User-data for single EC2 to install Docker, clone repo and run docker-compose
set -e

# update and install git, docker
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y git docker.io curl
  systemctl enable --now docker
else
  yum update -y
  yum install -y git docker curl
  systemctl enable --now docker
fi

# Install docker-compose (if not present)
if ! command -v docker-compose >/dev/null 2>&1; then
  curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose || true
fi

# clone repo and start services
cd /opt
if [ ! -d "DevOps" ]; then
  git clone https://github.com/Kedar7/DevOps.git || true
fi
cd DevOps/express_flask_docker
/usr/local/bin/docker-compose up -d || docker-compose up -d || true

# end
