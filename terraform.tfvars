aws_region  = "us-east-1"
environment = "production"

# VPC Configuration
vpc_name           = "prod-ecs-vpc"
vpc_cidr           = "10.0.0.0/16"
azs                = ["us-east-1a", "us-east-1b"]
private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
enable_nat_gateway = true
vpc_tags = {
  Terraform   = "true"
  Environment = "production"
}

# ECS Cluster
cluster_name = "prod-ecs-cluster"

# Frontend Configuration (Use your ECR repository URL)
frontend_image         = "056026787582.dkr.ecr.us-east-1.amazonaws.com/production-frontend:latest"
frontend_port          = 80
frontend_desired_count = 0  # Set to 0 until you push your application image
frontend_cpu           = 256
frontend_memory        = 512
frontend_env_vars = [
  {
    name  = "BACKEND_URL"
    value = "http://backend-alb-url"  # Update after deployment
  }
]

# Backend Configuration (Use your ECR repository URL)
backend_image         = "056026787582.dkr.ecr.us-east-1.amazonaws.com/production-backend:latest"
backend_port          = 3000
backend_desired_count = 0  # Set to 0 until you push your application image
backend_cpu           = 512
backend_memory        = 1024
backend_env_vars      = []

# RDS Configuration
db_name                      = "appdb"
db_username_ssm_parameter    = "/prod/rds/username"
db_password_ssm_parameter    = "/prod/rds/password"
db_allocated_storage         = 20
db_instance_class            = "db.t3.micro"

# Auto Scaling
cpu_target_value = 70

# SSM Secrets (optional - for application secrets)
ssm_secret_names = []
