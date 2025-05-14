terraform {
  backend "s3" {
    bucket = "terraform-state-0205"
    key    = "manual_kub_cluster/terraform.tfstate"
    region = "eu-north-1"
  }
}