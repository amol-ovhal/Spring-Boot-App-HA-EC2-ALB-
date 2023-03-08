resource "aws_key_pair" "application-pem" {
  key_name   = format("%s", "${var.env_name}-application-key")
  public_key = var.frontend_public_key
}


module "ha-ec2-alb" {
  source                         = "../tf-modules/ha-ec2-alb/"
  applicaton_name                = var.application_name
  env_name                       = var.env_name
  applicaton_port                = 80
  applicaton_health_check_target = "/"
  tg_protocol                    = "HTTP"
  healthy_threshold_target       = 5
  deregistration_delay           = 60

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  alb_dns_cname = [data.terraform_remote_state.network.outputs.dns_name]
  ttl           = "60"

  listener_arn                   = data.terraform_remote_state.network.outputs.alb_listener_arn
  priority                       = "98"
  listener_rule_condition        = "host-header"
  listener_rule_condition_values = var.listener_rule_condition_values

  iam_instance_profile_arn = "arn:aws:iam::371618603879:instance-profile/cw-monitoring-role"


  ami_id                  = var.application_ami_id
  instance_type           = var.instance_type
  instance_key_name       = aws_key_pair.application-pem.key_name
  security_groups         = [module.application_security_group.sg_id, data.terraform_remote_state.bastion.outputs.ssh_security_group]
  volume_size             = var.volume_size
  volume_encryption       = var.volume_encryption
  volume_type             = "gp3"
  instance_subnets        = [data.terraform_remote_state.network.outputs.pvt_subnet_ids[0], data.terraform_remote_state.network.outputs.pvt_subnet_ids[1]]
  launch_template_version = "$Latest"

  asg_health_check_type         = "EC2"
  asg_wait_for_elb_capacity     = 0
  asg_health_check_grace_period = 60
  stickiness_enabled            = true
  asg_min_size                  = var.asg_min_size
  asg_max_size                  = var.asg_max_size
  asg_desired_size              = var.asg_desired_size
  asg_tags                      = var.asg_tags

}

resource "aws_autoscaling_policy" "application-asg-policy" {
  name                      = "demo-application-asg-policy"
  adjustment_type           = "ChangeInCapacity"
  enabled                   = var.asg_policy_state
  autoscaling_group_name    = module.ha-ec2-alb.asg_name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "120"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = "60"
  }
}


resource "aws_autoscaling_policy" "application_mem_policy_up" {
  name                   = "demo-application-asg-mem-policy-up"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  enabled                = var.asg_policy_state
  autoscaling_group_name = module.ha-ec2-alb.asg_name
  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = "0"
    metric_interval_upper_bound = ""
  }
}

resource "aws_cloudwatch_metric_alarm" "application_mem_alarm_up" {
  alarm_name          = "demo-application-asg-mem-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "120"
  statistic           = "Average"
  threshold           = "90"

  dimensions = {
    AutoScalingGroupName = module.ha-ec2-alb.asg_name
  }

  alarm_description = "This metric monitor EC2 instance memory utilization"
  alarm_actions     = [aws_autoscaling_policy.application_mem_policy_up.arn]
}


resource "aws_autoscaling_policy" "application_mem_policy_down" {
  name                   = "demo-application-asg-mem-policy-down"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  enabled                = var.asg_policy_state
  autoscaling_group_name = module.ha-ec2-alb.asg_name
  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_lower_bound = ""
    metric_interval_upper_bound = "0"
  }

}

resource "aws_cloudwatch_metric_alarm" "application_mem_alarm_down" {
  alarm_name          = "demo-application-asg-mem-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = module.ha-ec2-alb.asg_name
  }

  alarm_description = "This metric monitor EC2 instance memory utilization"
  alarm_actions     = [aws_autoscaling_policy.application_mem_policy_down.arn]
}
