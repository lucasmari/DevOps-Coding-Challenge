provider "aws" {
  region = var.region
}

#-------------------------------------------------
#               ===== [ ECR ] =====               
#-------------------------------------------------

resource "aws_ecr_repository" "repo" {
  name = var.project_name

  encryption_configuration {
    encryption_type = "KMS"
  }

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

#-------------------------------------------------
#               ===== [ KMS ] =====               
#-------------------------------------------------

resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

#-------------------------------------------------
#               ===== [ S3 ] =====               
#-------------------------------------------------

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.project_name}-state"
  force_destroy = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = var.tags
}
