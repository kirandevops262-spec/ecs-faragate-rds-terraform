variable "name" {
  description = "Name prefix for ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
}

variable "frontend_port" {
  description = "Frontend container port"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend container port"
  type        = number
  default     = 3000
}
