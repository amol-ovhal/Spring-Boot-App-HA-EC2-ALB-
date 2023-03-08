data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "demo-tf-state"
    key    = "demo/network.tfstate"
    region = "ap-south-1"
  }
}

terraform {
  backend "s3" {
    bucket = "demo-tf-state"
    key    = "demo/bastion.tfstate"
    region = "ap-south-1"
  }
}