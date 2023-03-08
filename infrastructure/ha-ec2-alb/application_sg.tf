module "application_security_group" {
  source                             = "../tf-modules/security_group/"
  enable_whitelist_ip                = false
  enable_source_security_group_entry = true

  name_sg = format("%s-application-security-group", "${var.env_name}")
  vpc_id  = data.terraform_remote_state.network.outputs.vpc_id
  tags    = var.tags
  ingress_rule = {
    rules = {
      rule_list = [
        {
          description  = "ALB sg"
          from_port    = 80
          to_port      = 80
          protocol     = "tcp"
          cidr         = [""]
          source_SG_ID = [data.terraform_remote_state.network.outputs.web_sg_id]
        }
      ]
    }
  }
}