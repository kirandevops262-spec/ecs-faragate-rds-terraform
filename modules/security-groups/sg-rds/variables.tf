variable "name" {
  description = "Name prefix for security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "backend_ecs_security_group_id" {
  description = "Backend ECS security group ID"
  type        = string
}
