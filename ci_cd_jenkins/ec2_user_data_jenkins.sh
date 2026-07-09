#!/bin/bash
# User-data to provision EC2 with Jenkins, Docker, Node, Python, Git, PM2
set -e

# Update & install basics
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y openjdk-11-jdk git curl gnupg python3 python3-venv python3-pip
  # Node
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt-get install -y nodejs
  # Docker
  apt-get install -y docker.io
  systemctl enable --now docker
else
  yum update -y
  yum install -y java-11-openjdk-devel git curl python3 python3-pip
  # Node
  curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
  yum install -y nodejs
  # Docker
  yum install -y docker
  systemctl enable --now docker
fi

# Install pm2 for node process management
yarn_or_npm_installed=false
if command -v npm >/dev/null 2>&1; then
  npm install -g pm2
  yarn_or_npm_installed=true
fi

# Install Jenkins (Ubuntu/Debian instructions)
if [ -f /etc/debian_version ]; then
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
  apt-get update -y
  apt-get install -y jenkins
  systemctl enable --now jenkins
else
  # For Amazon Linux/RHEL, use generic rpm
  curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  yum install -y jenkins
  systemctl enable --now jenkins
fi

# Add ubuntu/ec2-user to docker group so Jenkins can access docker (if preferred)
usermod -aG docker ubuntu || usermod -aG docker ec2-user || true

# Clone repo (devops workspace) and prepare simple startup scripts
cd /opt
if [ ! -d "DevOps" ]; then
  git clone https://github.com/Kedar7/DevOps.git || true
fi

# Prepare Flask (venv) and Express (npm) startup using systemd or pm2
# For demonstration, create simple systemd unit files under /etc/systemd/system (optional)

cat > /opt/DevOps/ci_cd_jenkins/setup_services.sh <<'EOF'
#!/bin/bash
# Setup Flask service (systemd)
cd /opt/DevOps/express_flask_docker/backend || exit 0
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt

# Start Flask with nohup for demo (use gunicorn/systemd in production)
nohup python3 app.py &>/opt/flask.log &

# Setup Express
cd /opt/DevOps/express_flask_docker/frontend || exit 0
npm install
pm2 start index.js --name express-frontend
pm2 save
EOF

chmod +x /opt/DevOps/ci_cd_jenkins/setup_services.sh || true
/bin/bash /opt/DevOps/ci_cd_jenkins/setup_services.sh || true

# End of user-data
echo "ec2_user_data_jenkins finished"
