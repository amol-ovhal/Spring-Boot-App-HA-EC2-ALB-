module "mysql_security_group" {
  source                             = "../tf-modules/security_group/"
  enable_whitelist_ip                = true
  enable_source_security_group_entry = false

  name_sg = "mysql-security-group"
  vpc_id  = data.terraform_remote_state.network.outputs.vpc_id
  tags = {
    provisioner = "Terraform",
    owner       = "devops"
  }
  ingress_rule = {
    rules = {
      rule_list = [
        {
          description  = "mysql port"
          from_port    = 3306
          to_port      = 3306
          protocol     = "tcp"
          cidr         = ["173.31.0.0/16"]
          source_SG_ID = [""]
        }
      ]
    }
  }
}