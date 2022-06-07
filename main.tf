data "aws_caller_identity" "account1" {
  provider = aws.account1
}
data "aws_caller_identity" "account2" {
  provider = aws.account2
}

# VPC in Account 1

resource "aws_vpc" "cloud_ops_vpc" {
  provider             = aws.account1
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc"
  }
}
# Private subnet in Account 1

resource "aws_subnet" "private_subnet" {
  provider   = aws.account1
  vpc_id     = aws_vpc.cloud_ops_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "private_subnet"
  }
}


#  EC2 instance in the private subnet in Account 1

resource "aws_instance" "ec2_instance" {
  provider               = aws.account1
  ami                    = var.ami_ec2
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_role.name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]
  user_data              = <<EOF
  #!/bin/bash
  cd /tmp
  sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  sudo systemctl enable amazon-ssm-agent
  sudo systemctl start amazon-ssm-agent
  EOF 
  tags = {
    Name = "EC2_instance"
  }
}

# SG for the EC2 instance deployed in the private subnet in Account 1

resource "aws_security_group" "sg_ec2" {
  provider    = aws.account1
  name        = "sg_ec2"
  description = "Allow inbound traffic through port 22"
  vpc_id      = aws_vpc.cloud_ops_vpc.id

  ingress {
    cidr_blocks      = ["0.0.0.0/0", ]
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM role in Account 1


resource "aws_iam_role" "ec2_role" {
  provider           = aws.account1
  name               = "ec2_role"
  assume_role_policy = file("./policies/assume_role_policy.json")
}

# IAM instance profile in Account 1

resource "aws_iam_instance_profile" "ec2_role" {
  provider = aws.account1
  name     = "ec2_role"
  role     = aws_iam_role.ec2_role.name
}

# Attach Policies to Instance Role

#1 --> Policy for SSM

resource "aws_iam_policy_attachment" "AmazonSSMManagedInstanceCore" {
  provider   = aws.account1
  name       = "attach_AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.ec2_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#2 --> Policy for S3 Cross Account

resource "aws_iam_role_policy" "assume_role_in_s3" {
  provider = aws.account1
  name     = "assume_role_s3"
  role     = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::${data.aws_caller_identity.account2.account_id}/role/s3_role"
      },
    ]
  })
}


