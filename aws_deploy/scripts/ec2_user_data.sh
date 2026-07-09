#!/bin/bash
# EC2 user-data script to install Docker, Docker Compose and run the repo's docker-compose
set -e

# Update & install
apt-get update -y || yum update -y || true
# Install docker (attempt apt then yum)
if command -v apt-get >/dev/null 2>&1; then
  apt-get install -y docker.io git
  systemctl enable --now docker
else
  yum install -y docker git
  systemctl enable --now docker
fi

# Install docker-compose (v2 as plugin or classic)
if ! command -v docker-compose >/dev/null 2>&1; then
  # try using pip or curl install
  curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose || true
fi

# Clone repo and run docker-compose (assumes public repo)
cd /opt
git clone https://github.com/Kedar7/DevOps.git repo || true
cd repo/express_flask_docker
# Run compose
/usr/local/bin/docker-compose up -d || docker-compose up -d || true

# Exit
echo "User-data finished"
