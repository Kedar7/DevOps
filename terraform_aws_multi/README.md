Terraform AWS Deployment (Flask + Express)

This folder provides Terraform skeletons, user-data scripts, and helper utilities to deploy the previously created Flask backend and Express frontend in three different configurations.

Parts included

Part 1 - Single EC2:
- Provision a single EC2 and use user-data to install deps and start both apps (Flask on 5000, Express on 3000).
- Files: part1/main.tf, part1/user_data_part1.sh

Part 2 - Separate EC2 instances:
- Provision two EC2 instances (backend and frontend), with security groups allowing traffic between them and public access.
- Files: part2/main.tf, part2/user_data_backend.sh, part2/user_data_frontend.sh

Part 3 - ECR + ECS (containers + ALB):
- Create ECR repos, push images, create VPC skeleton, ECS cluster and services (Fargate recommended).
- Files: part3/main.tf (skeleton), scripts/build_and_push_ecr.sh

General notes
- Replace placeholder values (AMI IDs, key_name, region, account ids, S3 backend bucket, etc.) before applying.
- Use terraform init, plan, apply. Use a remote S3 backend for state (see backend.tf example below).
- Do NOT commit secrets. Use environment variables and IAM roles.

Quick start (customize variables):
- cd terraform_aws_multi/part1
- terraform init
- terraform plan -var-file="../vars.tfvars"
- terraform apply -var-file="../vars.tfvars"

Files added by this assistant are scaffolds and must be reviewed and filled with real values before running in your AWS account.
