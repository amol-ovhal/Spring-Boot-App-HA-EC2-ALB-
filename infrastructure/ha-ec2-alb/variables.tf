variable "region" {
  type        = string
  description = "Region"
  default     = "ap-south-1"
}

variable "env_name" {
  type    = string
  default = ""
}

variable "application_name" {
  type        = string
  description = "Name of the Application"
  default     = ""
}

variable "listener_rule_condition_values" {
  type    = list(string)
  default = ["application.amolovhal.com"]
}

variable "application_ami_id" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "volume_size" {
  type    = number
  default = 8
}
variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 1
}

variable "asg_desired_size" {
  type    = number
  default = 1
}

variable "frontend_public_key" {
  type        = string
  description = "pem key for application instances"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy7KR+fumA7WQkFGaJS0y0rn2EdR7P0v6ujl1oQxPFt1nCWwHeP6Q8XEp+PgeTiZcEuVSWaTkdYmuqvNieU/Got5KuNWfufci+0IUnW02gcMKWUgji9F9k4FAYACOaxepo+fsF3Xe1PBtt5pJdjGL/yB3bQbaJ/0dhIycBpFvkZ8B2AGtIMlSi1jcvWiSU9yi10fkqd54kangSaPge1xQcGvZ5vkKrK5LMaUun+iMaWqxDtxsqZwrPh7vZq4QaEBHIRx08KOa4h0KX/gISmDUdLDkhM2L889y1INuLpxTY48lrYRwrKXDg2tgWL4VEgAulEH504XUny6nL05GBoNdtr6EOS1VQKYVqggo75HEYGNg14Rn/clbB0g6MkvmnV1aGfijgRdhDhSXw+lWrRy7GHld6tJOlOEAETh5vUamF2vV5fN5MI3GgvX4moTjOHlwqFtJOQVzK6/+ia//mGzcXzIWBJVebTlroNltRRfwWSl37Y926KgRURlLY6A7/rOc= ubuntu@ip-172-31-41-30"
}

variable "asg_tags" {
  default = [
    {
      key                 = "node_exporter"
      value               = "enable"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "demo-application-asg"
      propagate_at_launch = false
    },
    {
      key                 = "env"
      value               = "demo"
      propagate_at_launch = true
    },
    {
      key                 = "component"
      value               = "application"
      propagate_at_launch = true
    },
    {
      key                 = "owner"
      value               = "devops"
      propagate_at_launch = true
    }
  ]
}

variable "volume_encryption" {
  type        = bool
  description = "(Optional) Whether to enable volume encryption. Defaults to false."
  default     = true
}

variable "asg_policy_state" {
  type    = bool
  default = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    env   = "demo"
    owner = "devops"
  }
}