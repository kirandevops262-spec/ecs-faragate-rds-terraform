variable "name" {
  description = "Name prefix for security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
}
