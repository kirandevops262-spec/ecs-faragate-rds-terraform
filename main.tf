# Data source to fetch DB credentials from SSM Parameter Store
data "aws_ssm_parameter" "db_username" {
  name = var.db_username_ssm_parameter
}

data "aws_ssm_parameter" "db_password" {
  name            = var.db_password_ssm_parameter
  with_decryption = true
}

module "iam" {
  source = "./modules/iam"

  cluster_name     = var.cluster_name
  service_name     = "app"
  aws_region       = var.aws_region
  ssm_secret_names = var.ssm_secret_names
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway
  tags               = var.vpc_tags
}

# ECR Repositories
module "ecr_frontend" {
  source          = "./modules/ecr"
  repository_name = "${var.environment}-frontend"
}

module "ecr_backend" {
  source          = "./modules/ecr"
  repository_name = "${var.environment}-backend"
}

# Security Groups - Frontend ALB
module "sg_frontend_alb" {
  source = "./modules/security-groups/sg-frontend-alb"

  name   = "${var.environment}-frontend"
  vpc_id = module.vpc.vpc_id
}

# Security Groups - Backend ALB
module "sg_backend_alb" {
  source = "./modules/security-groups/sg-backend-alb"

  name   = "${var.environment}-backend"
  vpc_id = module.vpc.vpc_id
}

# Security Groups - Frontend ECS
module "sg_frontend_ecs" {
  source = "./modules/security-groups/sg-frontend-ecs"

  name                  = "${var.environment}-frontend"
  vpc_id                = module.vpc.vpc_id
  container_port        = var.frontend_port
  alb_security_group_id = module.sg_frontend_alb.security_group_id
}

# Security Groups - Backend ECS
module "sg_backend_ecs" {
  source = "./modules/security-groups/sg-backend-ecs"

  name                  = "${var.environment}-backend"
  vpc_id                = module.vpc.vpc_id
  container_port        = var.backend_port
  alb_security_group_id = module.sg_backend_alb.security_group_id
}

# Frontend ALB
module "alb_frontend" {
  source = "./modules/alb"

  service_name          = "${var.environment}-frontend"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.sg_frontend_alb.security_group_id
  container_port        = var.frontend_port
}

# Backend ALB
module "alb_backend" {
  source = "./modules/alb"

  service_name          = "${var.environment}-backend"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.sg_backend_alb.security_group_id
  container_port        = var.backend_port
}

# ECS Cluster
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  cluster_name = var.cluster_name
}

# RDS MySQL Database
module "rds" {
  source = "./modules/rds"
  identifier             = "${var.environment}-mysql"
  db_name                = var.db_name
  db_username            = data.aws_ssm_parameter.db_username.value
  db_password            = data.aws_ssm_parameter.db_password.value
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  ecs_security_group_id  = module.sg_backend_ecs.security_group_id
  allocated_storage      = var.db_allocated_storage
  instance_class         = var.db_instance_class
}

# Frontend Service
module "ecs_service_frontend" {
  source = "./modules/ecs-service"

  service_name                 = "${var.environment}-frontend"
  cluster_id                   = module.ecs_cluster.cluster_id
  cluster_name                 = module.ecs_cluster.cluster_name
  desired_count                = var.frontend_desired_count
  container_port               = var.frontend_port
  container_name               = "frontend"
  container_image              = var.frontend_image
  task_cpu                     = var.frontend_cpu
  task_memory                  = var.frontend_memory
  target_group_arn             = module.alb_frontend.target_group_arn
  task_execution_role_arn      = module.iam.ecs_task_execution_role_arn
  task_role_arn                = module.iam.ecs_task_role_arn
  aws_region                   = var.aws_region
  ssm_secret_names             = []
  environment_variables        = var.frontend_env_vars
  listener_arn                 = module.alb_frontend.listener_arn
  task_execution_ssm_policy_id = module.iam.ecs_task_execution_ssm_policy_id
  cpu_target_value             = var.cpu_target_value
  private_subnet_ids           = module.vpc.private_subnet_ids
  ecs_tasks_security_group_id  = module.sg_frontend_ecs.security_group_id
}

# Backend Service
module "ecs_service_backend" {
  source = "./modules/ecs-service"

  service_name                 = "${var.environment}-backend"
  cluster_id                   = module.ecs_cluster.cluster_id
  cluster_name                 = module.ecs_cluster.cluster_name
  desired_count                = var.backend_desired_count
  container_port               = var.backend_port
  container_name               = "backend"
  container_image              = var.backend_image
  task_cpu                     = var.backend_cpu
  task_memory                  = var.backend_memory
  target_group_arn             = module.alb_backend.target_group_arn
  task_execution_role_arn      = module.iam.ecs_task_execution_role_arn
  task_role_arn                = module.iam.ecs_task_role_arn
  aws_region                   = var.aws_region
  ssm_secret_names             = var.ssm_secret_names
  environment_variables = concat(var.backend_env_vars, [
    {
      name  = "DB_HOST"
      value = module.rds.address
    },
    {
      name  = "DB_PORT"
      value = tostring(module.rds.port)
    },
    {
      name  = "DB_NAME"
      value = var.db_name
    }
  ])
  listener_arn                 = module.alb_backend.listener_arn
  task_execution_ssm_policy_id = module.iam.ecs_task_execution_ssm_policy_id
  cpu_target_value             = var.cpu_target_value
  private_subnet_ids           = module.vpc.private_subnet_ids
  ecs_tasks_security_group_id  = module.sg_backend_ecs.security_group_id
}
