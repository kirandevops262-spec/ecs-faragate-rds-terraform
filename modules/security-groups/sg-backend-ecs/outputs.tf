output "security_group_id" {
  description = "Backend ECS security group ID"
  value       = aws_security_group.backend_ecs.id
}
