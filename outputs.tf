output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs_cluster.cluster_name
}

output "frontend_ecr_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr_frontend.repository_url
}

output "backend_ecr_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr_backend.repository_url
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.endpoint
}

output "rds_address" {
  description = "RDS database address"
  value       = module.rds.address
}
