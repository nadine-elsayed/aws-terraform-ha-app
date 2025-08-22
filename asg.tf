resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity           = 2
  vpc_zone_identifier = module.vpc.nadine_private_subnets
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns          = [aws_lb_target_group.app_tg.arn]

  health_check_type           = "ELB"
  health_check_grace_period   = 300
}

resource "aws_autoscaling_attachment" "asg_alb" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  lb_target_group_arn   = aws_lb_target_group.app_tg.arn
}
