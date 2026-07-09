provider "aws" {
  region = var.aws_region
}

# Variables for AMI and sizes
variable "ami" { default = "<AMI_ID>" }
variable "instance_type" { default = "t3.micro" }

# VPC (minimal)
resource "aws_vpc" "v" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "pub" {
  vpc_id            = aws_vpc.v.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]
}

data "aws_availability_zones" "available" {}

# Security group allowing app ports and internal traffic
resource "aws_security_group" "sg" {
  name   = "two-instance-sg"
  vpc_id = aws_vpc.v.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
}

# Backend instance
resource "aws_instance" "backend" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.pub.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = file("user_data_backend.sh")
  tags = { Name = "flask-backend" }
}

# Frontend instance
resource "aws_instance" "frontend" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.pub.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = file("user_data_frontend.sh")
  tags = { Name = "express-frontend" }
}

output "backend_ip" { value = aws_instance.backend.public_ip }
output "frontend_ip" { value = aws_instance.frontend.public_ip }
