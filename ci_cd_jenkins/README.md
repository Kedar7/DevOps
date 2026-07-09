CI/CD with Jenkins for Flask (backend) and Express (frontend)

This folder contains scripts and example Jenkins pipelines to deploy the express_flask_docker project to an EC2 instance and automate deployment via Jenkins.

What is included
- ec2_user_data_jenkins.sh : User-data to provision an EC2 instance with Jenkins, Docker, Node, Python, Git, and PM2. It also clones the repo and sets up example services.
- scripts/deploy_flask.sh : Deployment helper used by Jenkins to restart Flask service
- scripts/deploy_express.sh : Deployment helper used by Jenkins to restart Express service
- jenkins/Jenkinsfile_flask : Declarative Jenkins pipeline for Flask app
- jenkins/Jenkinsfile_express : Declarative Jenkins pipeline for Express app
- systemd/flask.service : Example systemd unit to run Flask app via gunicorn (or use pm2)
- systemd/express.service : Example systemd unit to run Express app (or use pm2)

High-level steps
1. Launch an EC2 instance and use ec2_user_data_jenkins.sh as user-data (or run its steps manually).
2. Point Jenkins job to the repository and use the respective Jenkinsfile or configure pipeline to call scripts/deploy_flask.sh and deploy_express.sh
3. Configure GitHub webhooks to trigger Jenkins on push events.

Security & notes
- Do NOT commit secrets. Use environment variables or Jenkins credentials store.
- The user-data script installs Jenkins and starts it on port 8080. Secure Jenkins before exposing it publicly.

If you want, I can:
- Generate a ready-to-run AMI/user-data with your AWS specifics (needs AWS interaction).
- Walk through creating Jenkins jobs and configuring webhooks step-by-step.
