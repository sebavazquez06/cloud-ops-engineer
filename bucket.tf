# Public Subnet for NAT Gateway

resource "aws_subnet" "public_subnet" {
  provider   = aws.account1
  vpc_id     = aws_vpc.cloud_ops_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Public subnet"
  }
}


# Internet Gateway 

resource "aws_internet_gateway" "igw" {
  provider = aws.account1
  vpc_id   = aws_vpc.cloud_ops_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

# Elastic IP for NAT Gateway

resource "aws_eip" "elastic_ip" {
  provider = aws.account1
  vpc      = true
  tags = {
    Name = "EIP for NAT"
  }
}

# NAT Gateway

resource "aws_nat_gateway" "nat_gateway" {
  provider      = aws.account1
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "NAT Gateway"
  }
}

# Route tables & Subnets associations (for private and public subnets)

resource "aws_route_table" "private_route_table" {
  provider = aws.account1
  vpc_id   = aws_vpc.cloud_ops_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "Private Route table"
  }
}

resource "aws_route_table" "public_route_table" {
  provider = aws.account1
  vpc_id   = aws_vpc.cloud_ops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route table"
  }
}

resource "aws_route_table_association" "route_assoc_private" {
  provider       = aws.account1
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "route_assoc_public" {
  provider       = aws.account1
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


# Private bucket in Account 2

resource "aws_s3_bucket" "cloud_ops_bucket" {
  provider = aws.account2
  bucket   = var.bucket_name_for_EC2
  tags = {
    Name = "bucket-cloud-ops"
  }
}

resource "aws_s3_bucket_acl" "private_bucket" {
  provider = aws.account2
  bucket   = aws_s3_bucket.cloud_ops_bucket.id
  acl      = "private"
}


# Bucket policy to allow access to EC2 role


resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  provider = aws.account2
  bucket   = aws_s3_bucket.cloud_ops_bucket.id
  policy   = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  provider = aws.account2
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.account1.account_id}:role/ec2_role"]
    }
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::cloudopsbucket01/*",
      "arn:aws:s3:::cloudopsbucket01"
    ]
  }
}