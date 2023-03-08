variable "region" {
  type        = string
  description = "Region"
  default     = "ap-south-1"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    owner       = "devops"
    provisioner = "terraform"
  }
}

variable "endpoint" {
  description = "email id's for endpoint"
  type        = list(any)
  default     = ["amolovhal999@gmail.com"]
}