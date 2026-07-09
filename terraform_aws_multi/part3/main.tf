provider "aws" {
  region = var.aws_region
}

# ECR repositories
resource "aws_ecr_repository" "frontend" {
  name = "ef_frontend"
}
resource "aws_ecr_repository" "backend" {
  name = "ef_backend"
}

# Minimal VPC skeleton - fill out for production
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 0)
}

resource "aws_ecs_cluster" "this" {
  name = "ef-ecs-cluster"
}

# NOTE: Task definitions, IAM roles, ALB, target groups and services are intentionally left as placeholders.
# Implementing complete ECS+ALB Terraform requires many resources and careful IAM configuration.

output "ecr_frontend_uri" { value = aws_ecr_repository.frontend.repository_url }
output "ecr_backend_uri" { value = aws_ecr_repository.backend.repository_url }
output "ecs_cluster" { value = aws_ecs_cluster.this.id }
