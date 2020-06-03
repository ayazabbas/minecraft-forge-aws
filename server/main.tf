resource "aws_security_group" "server" {
  name        = "minecraft-forge-sg"
  description = "Allow inbound traffic to minecraft server"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    product = "minecraft-forge"
  }
}

resource "aws_security_group_rule" "allow_egress" {
  security_group_id = aws_security_group.server.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_users" {
  security_group_id = aws_security_group.server.id
  type              = "ingress"
  from_port         = 25565
  to_port           = 25565
  protocol          = "tcp"
  cidr_blocks       = var.allowed_user_ips
}

resource "aws_security_group_rule" "allow_admins" {
  security_group_id = aws_security_group.server.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_admin_ips
}


data "aws_iam_policy_document" "ec2_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "server" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::minecraft-forge-858463413507/*"]
  }
}

resource "aws_iam_policy" "server" {
  name        = "minecraft-forge-server-policy"
  description = "Permissions for minecraft forge EC2 instance."
  policy      = data.aws_iam_policy_document.server.json
}

resource "aws_iam_role" "server" {
  name               = "minecraft-forge-server-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assumerole.json
}

resource "aws_iam_role_policy_attachment" "server" {
  role       = aws_iam_role.server.name
  policy_arn = aws_iam_policy.server.arn
}

resource "aws_iam_instance_profile" "server" {
  name = "minecraft-forge-server-role"
  role = aws_iam_role.server.name
}

resource "aws_launch_template" "server" {
  name                   = "minecraft-forge-server-lt"
  instance_type          = "m5.large"
  key_name               = "main"
  user_data              = filebase64("files/userdata.sh")
  vpc_security_group_ids = [aws_security_group.server.id]
  image_id               = data.aws_ami.forge.id

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 16
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.server.name
  }
}

resource "aws_spot_fleet_request" "server" {
  iam_fleet_role                      = "arn:aws:iam::858463413507:role/aws-ec2-spot-fleet-tagging-role"
  spot_price                          = "0.09"
  target_capacity                     = 1
  instance_interruption_behaviour     = "stop"
  terminate_instances_with_expiration = true

  launch_template_config {
    launch_template_specification {
      id      = aws_launch_template.server.id
      version = aws_launch_template.server.latest_version
    }
    overrides {
      subnet_id = data.aws_subnet.main_public.id
    }
  }
}
