resource "aws_db_subnet_group" "nadine_db_subnet" {
  name       = "nadine-db-subnet-group"
  subnet_ids = var.private_subnets
  tags = {
    Name    = "nadine-db-subnet-group"
    Project = "nadine-project"
  }
}

resource "aws_db_instance" "nadine_mysql" {
  identifier              = "nadine-mysql-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.nadine_db_subnet.name
  vpc_security_group_ids = [var.ec2_sg_id]
  multi_az                = false
  publicly_accessible     = false
  username             = jsondecode(aws_secretsmanager_secret_version.db_secret_value.secret_string)["username"]
  password             = jsondecode(aws_secretsmanager_secret_version.db_secret_value.secret_string)["password"]
  skip_final_snapshot     = true
  deletion_protection     = false
  tags = {
    Name    = "nadine-mysql-db"
    Project = "nadine-project"
  }
  depends_on = [aws_secretsmanager_secret_version.db_secret_value]  # ensures the secret is created first
}
