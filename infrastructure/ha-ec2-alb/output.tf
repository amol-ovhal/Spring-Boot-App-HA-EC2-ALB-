output "application_sg_id" {
  value = module.application_security_group.sg_id
}
output "launch_template_name" {
  value = module.ha-ec2-alb.launch_template_name
}
output "launch_template_default_version" {
  value = module.ha-ec2-alb.launch_template_default_version
}
output "launch_template_latest_version" {
  value = module.ha-ec2-alb.launch_template_latest_version
}
output "target_group_arn" {
  value = module.ha-ec2-alb.target_group_arn
}
