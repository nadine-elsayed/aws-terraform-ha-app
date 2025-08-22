resource "aws_s3_bucket" "uploads" {
  bucket = "nadine-project-uploads"  # Change to a globally unique name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"  # SSE-S3
      }
    }
  }

  tags = {
    Name    = "nadine-uploads"
    Project = "nadine-project"
  }
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
