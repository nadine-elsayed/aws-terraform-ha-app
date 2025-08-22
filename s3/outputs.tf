output "s3_bucket_name" {
  value = aws_s3_bucket.uploads.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.uploads.arn
}
