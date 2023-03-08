module "bastion_security_group" {
  source                             = "../tf-modules/security_group/"
  enable_whitelist_ip                = true
  enable_source_security_group_entry = false

  name_sg = format("%s-bastion-security-group", "${var.env_name}")
  vpc_id  = data.terraform_remote_state.network.outputs.vpc_id
  tags    = var.tags
  ingress_rule = {
    rules = {
      rule_list = [
        {
          description  = "ssh port"
          from_port    = 22
          to_port      = 22
          protocol     = "tcp"
          cidr         = ["103.198.165.210/32"]
          source_SG_ID = [""]
        }
      ]
    }
  }
}