output "mysql_security_group" {
  value = module.mysql_security_group.sg_id
}
output "db_instance_endpoint" {
  value = aws_db_instance.mysql.address
}
output "db_instance_port" {
  value = aws_db_instance.mysql.port
}