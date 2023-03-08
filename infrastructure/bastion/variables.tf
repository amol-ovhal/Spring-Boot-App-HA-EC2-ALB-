variable "region" {
  type        = string
  description = "Region"
  default     = "ap-south-1"
}

variable "count_ec2_instance" {
  description = "number of ec2 instance"
  type        = number
  default     = 1
}

variable "name" {
  description = "Name of bastion"
  type        = string
  default     = ""
}
variable "public_ip" {
  description = "Public Ip "
  type        = bool
  default     = false
}

variable "env_name" {
  description = "environment name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "volume_size" {
  description = "volume size"
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "volume type"
  type        = string
  default     = "gp2"
}

variable "ami_id" {
  description = "Name of Launch configuration"
  type        = string
  default     = ""
}
variable "bastion_public_key" {
  description = "Public Key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy7KR+fumA7WQkFGaJS0y0rn2EdR7P0v6ujl1oQxPFt1nCWwHeP6Q8XEp+PgeTiZcEuVSWaTkdYmuqvNieU/Got5KuNWfufci+0IUnW02gcMKWUgji9F9k4FAYACOaxepo+fsF3Xe1PBtt5pJdjGL/yB3bQbaJ/0dhIycBpFvkZ8B2AGtIMlSi1jcvWiSU9yi10fkqd54kangSaPge1xQcGvZ5vkKrK5LMaUun+iMaWqxDtxsqZwrPh7vZq4QaEBHIRx08KOa4h0KX/gISmDUdLDkhM2L889y1INuLpxTY48lrYRwrKXDg2tgWL4VEgAulEH504XUny6nL05GBoNdtr6EOS1VQKYVqggo75HEYGNg14Rn/clbB0g6MkvmnV1aGfijgRdhDhSXw+lWrRy7GHld6tJOlOEAETh5vUamF2vV5fN5MI3GgvX4moTjOHlwqFtJOQVzK6/+ia//mGzcXzIWBJVebTlroNltRRfwWSl37Y926KgRURlLY6A7/rOc= ubuntu@ip-172-31-41-30"
}
variable "instance_type" {
  description = "Name of Launch configuration"
  type        = string
  default     = ""
}
variable "security_groups" {
  description = "Name of Launch configuration"
  type        = list(string)
  default     = []
}