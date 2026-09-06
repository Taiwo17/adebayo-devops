resource "aws_s3_bucket_versioning" "terraform_lab" {
  bucket = aws_s3_bucket.terraform_lab.id

  versioning_configuration {
    status = "Enabled"
  }
}