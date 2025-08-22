module "vpc" {
  source = "./vpc"
  azs    = ["eu-north-1a", "eu-north-1b"]
}
module "rds" {
  source = "./rds"
  ec2_sg_id = aws_security_group.ec2_sg.id
  private_subnets = module.vpc.nadine_private_subnets  
}
module "iam" {
  source       = "./iam"
  s3_bucket_arn = module.s3.s3_bucket_arn
  db_secret_arn = module.rds.db_secret_arn
}

module "s3" {
  source = "./s3"
}
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
