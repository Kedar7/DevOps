AWS Deployment Guide for express_flask_docker

This folder contains step-by-step instructions, cost-safety tips, and small automation scripts to deploy the express_flask_docker project to AWS using three approaches. Replace placeholder values (e.g., <AWS_REGION>, <ACCOUNT_ID>, <ECR_REPO>, <KEY_NAME>) before running commands.

Important cost note
- Stop or terminate EC2 instances when not testing. Use the free tier cautiously.

1) Single EC2 instance (both frontend + backend on one VM)
- Use a t3.micro/t2.micro (free-tier eligible in some accounts).
- Create a security group allowing inbound 22 (SSH), 80 (HTTP), 3000 and 5000 if needed.
- Launch an Amazon Linux 2 or Ubuntu instance with an SSH key pair.
- Use this user-data script (scripts/ec2_user_data.sh) when launching, which installs Docker & Docker Compose, clones this repo, and runs docker-compose from express_flask_docker.
- After launch: ssh into instance, verify docker ps, visit http://<EC2_PUBLIC_IP>:3000.
- Stop instance when done: aws ec2 stop-instances --instance-ids <id>

2) Separate EC2 instances (frontend and backend on different VMs)
- Launch two EC2 instances with their own security groups or one SG that permits necessary traffic between them.
- On backend instance: run the Flask app or docker-compose exposing port 5000. Ensure inbound from frontend's IP or SG.
- On frontend instance: configure BACKEND_URL to http://<BACKEND_PRIVATE_IP>:5000/submit or use Elastic IP/Load Balancer.
- Use systemd to run services or docker-compose for stability.

3) Docker containers with ECR, ECS, and VPC
- Build and push images to ECR (scripts/ecr_push.sh). Requires AWS CLI configured and `aws ecr create-repository` for each image.
- Create a VPC with public/private subnets (use CloudFormation or Terraform). Keep services in a private subnet and use an Application Load Balancer in public subnets.
- Create an ECS cluster (Fargate recommended for simplicity). Define Task Definitions for frontend and backend referencing ECR images.
- Configure Service, Task Role, ALB target groups, and security groups to allow HTTP traffic.
- Use AWS Secrets Manager or SSM Parameter Store for secrets (DB credentials, etc.).

Automation scripts included
- scripts/ec2_user_data.sh  : user-data to provision a single EC2 and run docker-compose
- scripts/ecr_push.sh       : helper to tag, login and push images to ECR (requires AWS CLI configured)

Terraform skeleton (terraform/main.tf)
- Minimal skeleton demonstrates creating ECR repositories and an ECS cluster. Customize further before applying.

Testing & safety
- Test with small instance types and stop resources after testing.
- Do not commit credentials. Use environment variables and IAM roles.

References
- Docker on EC2: https://docs.docker.com/engine/install/
- ECR/ECS quickstart: https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html
- AWS Free Tier: https://aws.amazon.com/free

Submission
- Provide the repository link and the deployed app URL. Keep instances stopped when not in use to save cost.
