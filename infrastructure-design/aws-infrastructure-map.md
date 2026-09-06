# Adebayo AWS Infrastructure Map

## 1. Networking

Adebayo-VPC
- CIDR: 10.0.0.0/16
- Region: us-east-1

Public Subnets:
- 10.0.1.0/24 — us-east-1b
- 10.0.4.0/24 — us-east-1a

Private Subnets:
- 10.0.2.0/24 — us-east-1b
- 10.0.3.0/24 — us-east-1a

Internet Gateway:
- Adebayo-IGW

Routing:
- Public route table → 0.0.0.0/0 → Internet Gateway
- Both public subnets use the public route table
- Private subnet 10.0.2.0/24 uses Adebayo-Private-RT
- Private subnet 10.0.3.0/24 currently uses the VPC main route table
- No NAT Gateway currently exists

## 2. Security

Adebayo-ALB-SG:
- HTTP 80 from Internet
- HTTPS 443 from Internet

Adebayo-ASG-App-SG:
- HTTP 80 from Adebayo-ALB-SG only

Adebayo-App-SG:
- SSH 22 from approved IP

Adebayo-RDS-SG:
- PostgreSQL 5432 from Adebayo-App-SG only

## 3. Load Balancing and Compute

Application Load Balancer:
- Adebayo-ALB
- Internet-facing
- Uses both public subnets
- Uses Adebayo-ALB-SG

Listeners:
- HTTP 80 → redirect to HTTPS 443
- HTTPS 443 → forward to Adebayo-ASG-TG

Target Group:
- Adebayo-ASG-TG
- HTTP port 80
- Health check path: /
- Target type: instance

Auto Scaling Group:
- Adebayo-ASG
- Minimum: 2
- Desired: 2
- Maximum: 3
- Health check: ELB
- Uses Adebayo-ASG-Launch-Template

Launch Template:
- Adebayo-ASG-Launch-Template
- Current default version: 5
- Uses Adebayo-ASG-App-SG
- Uses Adebayo-EC2-ECR-Role
- Application version is updated by GitHub Actions

## 4. Database

RDS:
- Identifier: adebayo-postgres-db
- Engine: PostgreSQL 18.3
- Instance class: db.t4g.micro
- Publicly accessible: false
- Encrypted: true
- Multi-AZ: false

DB Subnet Group:
- adebayo-rds-subnet-group
- Uses both private subnets

Database Security:
- Adebayo-RDS-SG
- PostgreSQL 5432 from Adebayo-App-SG

## 5. Container Registry

ECR Repository:
- adebayo-docker-app
- Private repository
- AES256 encryption
- Mutable tags

Terraform responsibility:
- Manage the ECR repository

GitHub Actions responsibility:
- Build Docker images
- Tag images using Git commit SHA
- Push images to ECR

## 6. DNS and HTTPS

Route 53 Hosted Zone:
- devops.taiwoadefowope.com

Application DNS:
- app.devops.taiwoadefowope.com
- A Alias → Adebayo-ALB

ACM:
- Certificate for app.devops.taiwoadefowope.com
- DNS validated
- Status: ISSUED
- Used by ALB HTTPS listener

## 7. IAM

EC2 Runtime Role:
- Adebayo-EC2-ECR-Role
- AmazonEC2ContainerRegistryReadOnly
- Allows EC2 instances to pull images from ECR

GitHub Deployment Role:
- Adebayo-GitHub-Deploy-Role
- Assumed by GitHub Actions using OIDC
- Uses Adebayo-GitHub-Deploy-Policy

## 8. Infrastructure vs Application Ownership

Infrastructure as Code should manage:
- VPC
- Subnets
- Internet Gateway
- Route Tables
- Security Groups
- ECR Repository
- IAM infrastructure
- ALB
- Target Group
- Auto Scaling infrastructure
- RDS infrastructure
- Route 53 infrastructure
- ACM infrastructure

CI/CD should manage:
- Application tests
- Docker builds
- Docker image versions
- ECR image pushes
- Application releases
- Deployment of application versions

## 9. Dependency Map

Internet
  ↓
Route 53
  ↓
ALB + ACM
  ↓
Target Group
  ↓
Auto Scaling Group
  ↓
Launch Template
  ↓
EC2 + Docker
  ↓
Application

Supporting infrastructure:

VPC
├── Public Subnets
│   └── ALB / current ASG instances
├── Private Subnets
│   └── RDS Subnet Group
├── Security Groups
├── Internet Gateway
└── Route Tables

Application delivery:

GitHub
  ↓ OIDC
GitHub Deployment IAM Role
  ↓
Docker Build
  ↓
ECR
  ↓
Launch Template Version
  ↓
ASG Instance Refresh
  ↓
Production Application
