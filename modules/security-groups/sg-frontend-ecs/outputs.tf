output "security_group_id" {
  description = "Frontend ECS security group ID"
  value       = aws_security_group.frontend_ecs.id
}
