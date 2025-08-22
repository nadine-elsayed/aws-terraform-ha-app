data "template_file" "userdata" {
  template = file("${path.module}/user.sh")

  vars = {
    db_host = module.rds.rds_endpoint
  }
}
# --- Launch Template ---
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-launch-template"
  image_id      = "ami-0867f6e2fa5f9f84e" # Ubuntu 22.04 AMI in eu-north-1 (check latest if needed)
  instance_type = "t3.micro"
  key_name      = "nadine-keypair"  # Replace with your key pair name

  iam_instance_profile {
    name = module.iam.ec2_instance_profile_name
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Use the rendered user data
  user_data = base64encode(data.template_file.userdata.rendered)

  lifecycle {
    create_before_destroy = true
  }
}

