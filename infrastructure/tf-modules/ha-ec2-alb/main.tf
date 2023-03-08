resource "aws_lb_target_group" "target_group" {
  name                 = "${var.env_name}-${var.applicaton_name}-alb-tg"
  port                 = var.applicaton_port
  target_type          = var.tg_target_type
  protocol             = var.tg_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  health_check {
    path              = var.applicaton_health_check_target
    port              = var.applicaton_port
    protocol          = var.tg_protocol
    healthy_threshold = var.healthy_threshold_target
  }
  stickiness {
    enabled         = var.stickiness_enabled
    cookie_duration = var.stickiness_cookie_duration
    type            = var.stickiness_type
  }
}

resource "aws_lb_listener_rule" "listner_rule" {
  listener_arn = var.listener_arn
  priority     = var.priority
  action {
    type             = var.action_type
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  condition {
    host_header {
      values = var.listener_rule_condition_values
    }
  }
}

resource "aws_launch_template" "launch_template" {
  name                    = "${var.env_name}-${var.applicaton_name}-lt"
  disable_api_termination = var.disable_api_termination
  disable_api_stop        = var.disable_api_stop
  image_id                = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.instance_key_name
  vpc_security_group_ids  = var.security_groups
  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }
  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted   = var.volume_encryption
    }
  }
  monitoring {
    enabled = var.monitoring_enabled
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.env_name}-${var.applicaton_name}"
    }
  }
  tags = {
    owner       = "devops",
    env         = "${var.env_name}",
    provisioner = "terraform"
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "${var.env_name}-${var.applicaton_name}-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_size
  wait_for_elb_capacity     = var.asg_wait_for_elb_capacity
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  force_delete              = var.asg_force_delete
  default_cooldown          = var.asg_default_cooldown
  target_group_arns         = ["${aws_lb_target_group.target_group.arn}"]
  vpc_zone_identifier       = var.instance_subnets
  termination_policies      = var.asg_termination_policies
  suspended_processes       = var.asg_suspended_processes

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = var.launch_template_version
  }
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
  lifecycle {
    create_before_destroy = true
  }

  tags = var.asg_tags
}
