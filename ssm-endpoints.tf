#Security Group for Endpoints

resource "aws_security_group" "sg_endpoints" {
  provider    = aws.account1
  name        = "sg_endpoints"
  description = "allow inbound HTTPS (port 443)"
  vpc_id      = aws_vpc.cloud_ops_vpc.id

  ingress {
    description = "Allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#  SSM, EC2Messages, and SSMMessages endpoints for SSM

resource "aws_vpc_endpoint" "ssm" {
  provider            = aws.account1
  vpc_id              = aws_vpc.cloud_ops_vpc.id
  subnet_ids          = [aws_subnet.private_subnet.id]
  service_name        = "com.amazonaws.${var.region-account1}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.sg_endpoints.id
  ]

}

resource "aws_vpc_endpoint" "ec2messages" {
  provider            = aws.account1
  vpc_id              = aws_vpc.cloud_ops_vpc.id
  subnet_ids          = [aws_subnet.private_subnet.id]
  service_name        = "com.amazonaws.${var.region-account1}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.sg_endpoints.id
  ]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  provider            = aws.account1
  vpc_id              = aws_vpc.cloud_ops_vpc.id
  subnet_ids          = [aws_subnet.private_subnet.id]
  service_name        = "com.amazonaws.${var.region-account1}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.sg_endpoints.id
  ]
}
