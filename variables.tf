
variable "ami_ec2" {
  type        = string
  description = "AMI of the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "region-account1" {
  type        = string
  description = "Region where the resources are deployed in Account1"
}

variable "bucket_name_for_EC2" {
  type        = string
  description = "Name of the bucket located in Account 2"
}

