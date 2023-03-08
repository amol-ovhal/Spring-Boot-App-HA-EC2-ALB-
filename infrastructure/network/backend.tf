terraform {
  backend "s3" {
    bucket = "demo-tf-state"
    key    = "demo/network.tfstate"
    region = "ap-south-1"
  }
}