output "security_group_id" {
  description = "Frontend ALB security group ID"
  value       = aws_security_group.frontend_alb.id
}
