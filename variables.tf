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
  default     = true
}

variable "vpc_tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "ssm_secret_names" {
  description = "List of SSM parameter names for secrets"
  type        = list(string)
  default     = []
}

variable "cpu_target_value" {
  description = "Target CPU utilization for service auto-scaling"
  type        = number
  default     = 70
}

# Frontend variables
variable "frontend_port" {
  description = "Frontend container port"
  type        = number
  default     = 80
}

variable "frontend_desired_count" {
  description = "Desired number of frontend tasks"
  type        = number
  default     = 2
}

variable "frontend_image" {
  description = "Frontend container image (ECR repository URL with tag)"
  type        = string
}

variable "frontend_cpu" {
  description = "Frontend task CPU"
  type        = number
  default     = 256
}

variable "frontend_memory" {
  description = "Frontend task memory"
  type        = number
  default     = 512
}

variable "frontend_env_vars" {
  description = "Frontend environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Backend variables
variable "backend_port" {
  description = "Backend container port"
  type        = number
  default     = 3000
}

variable "backend_desired_count" {
  description = "Desired number of backend tasks"
  type        = number
  default     = 2
}

variable "backend_image" {
  description = "Backend container image (ECR repository URL with tag)"
  type        = string
}

variable "backend_cpu" {
  description = "Backend task CPU"
  type        = number
  default     = 512
}

variable "backend_memory" {
  description = "Backend task memory"
  type        = number
  default     = 1024
}

variable "backend_env_vars" {
  description = "Backend environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# RDS variables
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username_ssm_parameter" {
  description = "SSM Parameter Store path for DB username"
  type        = string
  default     = "/prod/rds/username"
}

variable "db_password_ssm_parameter" {
  description = "SSM Parameter Store path for DB password"
  type        = string
  default     = "/prod/rds/password"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
