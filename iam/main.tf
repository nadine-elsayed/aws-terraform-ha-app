# ==========================
# IAM Role for EC2
# ==========================
resource "aws_iam_role" "ec2_role" {
  name = "nadine-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# ==========================
# IAM Policy for S3 access
# ==========================
resource "aws_iam_policy" "ec2_s3_access" {
  name = "nadine-ec2-s3-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# ==========================
# IAM Policy for Secrets Manager access
# ==========================
resource "aws_iam_policy" "ec2_secrets_access" {
  name        = "nadine-ec2-secrets-access"
  description = "Allow EC2 to get RDS credentials from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = var.db_secret_arn
      }
    ]
  })
}

# ==========================
# Attach S3 policy to EC2 role
# ==========================
resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_access.arn
}

# ==========================
# Attach Secrets Manager policy to EC2 role
# ==========================
resource "aws_iam_role_policy_attachment" "ec2_secrets_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_secrets_access.arn
}

# ==========================
# Attach SSM Managed Instance Core policy
# ==========================
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ==========================
# EC2 Instance Profile
# ==========================
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "nadine-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ==========================
# Variables for this module
# ==========================
variable "db_secret_arn" {
  type        = string
  description = "ARN of the RDS secret to allow EC2 access"
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket to allow EC2 access"
}
