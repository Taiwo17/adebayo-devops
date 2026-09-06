resource "terraform_data" "adebayo_demo" {
  input = "Adebayo Terraform Fundamentals - Updated"
}

resource "aws_s3_bucket" "terraform_lab" {
  bucket = "adebayo-terraform-lab-120685574103"

  tags = {
    Name = "Adebayo-Terraform-Lab"
  }
}