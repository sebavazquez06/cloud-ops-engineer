
# CloudOps Project

In this project I created a complete infrastructure using two AWS accounts. The goal is to create an EC2 instance in a private subnet in the first account and allow access to a S3 bucket on the second account.
Many resuorces were deployed to achieve this objective.



## Resources deployed in both accounts

- VPC

- Private and Public Subnet
- EC2 Instance

- Security Groups
- Route tables

- Interface endpoints for using SSM
- Internet Gateway

- NAT Gateway
- Elastic IP

- Bucket
- Roles

- Policies

- Backend in S3



## Credentials configuration

It´s necessary to configure the credentials for both accounts in:
**~/.aws/credentials**. Copy and paste the code below and replace the values from **aws_access_keys** and **aws_secret_keys**.
```http
[account1]
aws_access_key_id = #########################
aws_secret_access_key = #########################

[account2]
aws_access_key_id = #########################
aws_secret_access_key = #########################
```

## Input variables

#### Variables used in the project



| Variable | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `ami_ec2` | `string` | **Required**. The ami of the EC2 instance |
| `instance_type` | `string` | **Required**. Instance type |
| `region-account1` | `string` | **Required**. Region where the resources are deployed in Account1 |
| `bucket_name_for_EC2` | `string` | **Required**. Name of the bucket located in Account 2 |



## Author

- [@SebastianVazquez](github.com/sebavazquez06)

