provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Adebayo-DevOps"
      Environment = "training"
      ManagedBy   = "Terraform"
    }
  }
}