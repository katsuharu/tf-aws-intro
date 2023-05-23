# VPC/network
module "vpc" {
  source = "./modules/vpc"

  availability_zones         = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24"]
}

# EC2
module "ec2" {
  source = "./modules/ec2"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]
  user_data = <<EOF
#!/bin/bash

yum -y install httpd
systemctl enable httpd.service
systemctl start httpd.service
EOF
}
