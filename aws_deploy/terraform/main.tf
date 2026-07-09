// Terraform skeleton: create ECR repos and ECS cluster (Fargate)
// Fill providers, variables and customize as needed before running

terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "frontend" {
  name = var.ecr_frontend_name
}

resource "aws_ecr_repository" "backend" {
  name = var.ecr_backend_name
}

resource "aws_ecs_cluster" "this" {
  name = "express-flask-cluster"
}

// Note: Task definitions, services, ALB and IAM roles are intentionally left as placeholders.
// Use official Terraform AWS provider docs to expand this skeleton.
