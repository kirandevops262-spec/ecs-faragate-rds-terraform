# Setup Instructions

## 1. Create SSM Parameters for RDS Credentials

Before running `terraform apply`, create the SSM parameters:

```bash
# Create DB username parameter
aws ssm put-parameter \
  --name "/prod/rds/username" \
  --value "admin" \
  --type "String" \
  --region us-east-1

# Create DB password parameter (SecureString for encryption)
aws ssm put-parameter \
  --name "/prod/rds/password" \
  --value "YourStrongPassword123!" \
  --type "SecureString" \
  --region us-east-1
```

## 2. Update ECR Image URLs in terraform.tfvars

Replace `<AWS_ACCOUNT_ID>` with your actual AWS account ID:

```hcl
frontend_image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/production-frontend:latest"
backend_image  = "123456789012.dkr.ecr.us-east-1.amazonaws.com/production-backend:latest"
```

Or use the ECR repository URLs from outputs:
```bash
terraform output frontend_ecr_url
terraform output backend_ecr_url
```

## 3. Build and Push Docker Images to ECR

```bash
# Get your AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

# Build and push frontend
docker build -t production-frontend:latest ./frontend
docker tag production-frontend:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/production-frontend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/production-frontend:latest

# Build and push backend
docker build -t production-backend:latest ./backend
docker tag production-backend:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/production-backend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/production-backend:latest
```

## 4. Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

## 5. Verify Deployment

```bash
# Get ALB DNS names
terraform output frontend_alb_dns_name
terraform output backend_alb_dns_name

# Get RDS endpoint
terraform output rds_endpoint

# Test frontend
curl http://$(terraform output -raw frontend_alb_dns_name)

# Test backend
curl http://$(terraform output -raw backend_alb_dns_name)
```

## Notes

- DB credentials are stored securely in SSM Parameter Store
- Images are pulled from your ECR repositories
- ECS tasks have IAM permissions to pull from ECR and read SSM parameters
- RDS credentials are never stored in Terraform state or code
