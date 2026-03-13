variable "service_name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "container_port" {
  type = number
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "target_group_arn" {
  type = string
}

variable "task_execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ssm_secret_names" {
  type    = list(string)
  default = []
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "listener_arn" {
  type = string
}

variable "task_execution_ssm_policy_id" {
  type = string
}

variable "cpu_target_value" {
  type = number
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_tasks_security_group_id" {
  type = string
}
