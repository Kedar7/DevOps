variable "region" {
  type = string
  default = "us-east-1"
}

variable "ecr_frontend_name" {
  type = string
  default = "ef_frontend"
}

variable "ecr_backend_name" {
  type = string
  default = "ef_backend"
}
