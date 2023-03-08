provider "aws" {
  region = "ap-south-1"
}

resource "aws_db_instance" "mysql" {
  vpc_security_group_ids = [module.mysql_security_group.sg_id]
  allocated_storage      = 20
  storage_type           = "gp3"
  identifier             = "app-db"
  engine                 = "mysql"
  engine_version         = "8.0.28"
  instance_class         = "db.t2.micro"
  username               = "admin"
  password               = "Admin#123"
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "appdb_subnet_group"
  subnet_ids = [data.terraform_remote_state.network.outputs.public_subnet_ids[0], data.terraform_remote_state.network.outputs.public_subnet_ids[1]]
}