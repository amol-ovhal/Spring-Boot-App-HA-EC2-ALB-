output "instance_id" {
  value = aws_instance.ec2.*.id
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.ec2.*.private_ip
}

output "ssh_security_group" {
  value = module.bastion_security_group.sg_id
}