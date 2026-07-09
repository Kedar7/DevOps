provider "aws" {
  region = var.aws_region
}

# NOTE: Replace ami with a valid Ubuntu/AMZN AMI for your region
variable "instance_ami" { default = "<AMI_ID>" }
variable "instance_type" { default = "t3.micro" }

resource "aws_security_group" "single_sg" {
  name        = "single-instance-sg"
  description = "Allow SSH and app ports"
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

resource "aws_instance" "single" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.single_sg.id]
  user_data = file("user_data_part1.sh")
  tags = { Name = "flask-express-single" }
}

output "single_instance_ip" {
  value = aws_instance.single.public_ip
}
