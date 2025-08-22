variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for RDS"
}
variable "ec2_sg_id" {
  type        = string
  description = "EC2 Security Group ID to allow access from EC2 to RDS"
}
