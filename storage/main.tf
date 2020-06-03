data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  bucket = "minecraft-forge-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  tags = {
    product = "minecraft-forge-server"
  }
}
