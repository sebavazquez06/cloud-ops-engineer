
# CloudOps Project

In this project I created a complete infrastructure using two AWS accounts. The goal is to create an EC2 instance in a private subnet in the first account and allow access to a S3 bucket on the second account.
Many resources were deployed to achieve this objective.



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

- S3 Backend to store tfstate file



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



## Deploy infrastructure

To deploy this project first you need to clone the repository locally. For that, you need to run:

```bash
  git clone git@github.com:sebavazquez06/cloud-ops-engineer.git
```

Once cloned, you run the following command:

```bash
  terraform apply -var-file=global.tfvars
```


## Destroy infrastructure

To destroy the whole infrastructure you need to run:

```bash
  terraform destroy -var-file=global.tfvars
```

## EC2 login and bucket query 

To login to the EC2 instance you need to go to **EC2** service and click "Connect". Use **SSM** service to access the instance. Once inside, running the following command, you will be able to access the bucket on the second account:

```bash
  aws s3 ls s3://cloudopsbucket01
```
## Contributing

Contributions are always welcome!
Thanks for reading!




## Author

- [@SebastianVazquez](github.com/sebavazquez06)

