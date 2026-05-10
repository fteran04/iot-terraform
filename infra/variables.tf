variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-02b73f22d01a213cf"  
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = "subnet-03e326867a44355f7"  
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID (us-east-1)"
  type        = string
  default     = "ami-0a59ec92177ec3fad"
}

variable "key_name" {
  default = "vockey"
  description = "Name of the EC2 key pair for SSH access"
  type        = string
}

variable "dockerhub_username" {
  default     = "federicoteran04"
  description = "Docker Hub username where images are pushed"
  type        = string
}

variable "db_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "mi_usuario"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
  default     = "mi_password"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "tareas_db"
}

variable "rabbitmq_user" {
  description = "RabbitMQ username"
  type        = string
  default     = "admin"
}

variable "rabbitmq_password" {
  description = "RabbitMQ password"
  type        = string
  sensitive   = true
  default     = "admin"
}
