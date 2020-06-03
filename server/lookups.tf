data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

data "aws_subnet" "main_public" {
  filter {
    name   = "tag:Name"
    values = ["main-sn-public"]
  }
}

data "aws_ami" "forge" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["minecraft-forge-20-06-03-2128"]
  }
}
