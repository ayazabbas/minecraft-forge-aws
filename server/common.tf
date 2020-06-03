
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-storage-858463413507"
    region         = "eu-west-1"
    key            = "minecraft-forge-aws/server"
    dynamodb_table = "terraform_state_lock"
  }
}
