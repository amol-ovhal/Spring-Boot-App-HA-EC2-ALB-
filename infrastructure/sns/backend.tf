terraform {
  backend "s3" {
    bucket = "demo-tf-state"
    key    = "demo/sns.tfstate"
    region = "ap-south-1"
  }
}