VPC_CIDR = "10.100.0.0/16"
ENV = "prod"
PUBLIC_SUBNET_CIDR = ["10.100.0.0/24","10.100.1.0/24"]
PRIVATE_SUBNET_CIDR = ["10.0.100.100/24","10.100.101.0/24"] // we have to make sure that these cidr ranges do not overlap with others