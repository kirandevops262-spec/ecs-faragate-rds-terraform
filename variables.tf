variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC to create"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDRs for private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT gateway"
  type        = bool
}

variable "vpc_tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
}

variable "ssm_secret_names" {
  description = "List of SSM parameter names for secrets"
  type        = list(string)
}

variable "cpu_target_value" {
  description = "Target CPU utilization for service auto-scaling"
  type        = number
}

# Frontend variables
variable "frontend_port" {
  description = "Frontend container port"
  type        = number
}

variable "frontend_desired_count" {
  description = "Desired number of frontend tasks"
  type        = number
}

variable "frontend_image" {
  description = "Frontend container image (ECR repository URL with tag)"
  type        = string
}

variable "frontend_cpu" {
  description = "Frontend task CPU"
  type        = number
}

variable "frontend_memory" {
  description = "Frontend task memory"
  type        = number
}

variable "frontend_env_vars" {
  description = "Frontend environment variables"
  type = list(object({
    name  = string
    value = string
  }))
}

# Backend variables
variable "backend_port" {
  description = "Backend container port"
  type        = number
}

variable "backend_desired_count" {
  description = "Desired number of backend tasks"
  type        = number
}

variable "backend_image" {
  description = "Backend container image (ECR repository URL with tag)"
  type        = string
}

variable "backend_cpu" {
  description = "Backend task CPU"
  type        = number
}

variable "backend_memory" {
  description = "Backend task memory"
  type        = number
}

variable "backend_env_vars" {
  description = "Backend environment variables"
  type = list(object({
    name  = string
    value = string
  }))
}

# RDS variables
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username_ssm_parameter" {
  description = "SSM Parameter Store path for DB username"
  type        = string
}

variable "db_password_ssm_parameter" {
  description = "SSM Parameter Store path for DB password"
  type        = string
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}
