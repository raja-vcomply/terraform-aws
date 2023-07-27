# modules/vpc/main.tf

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  # instance_tenancy = "default" # default, dedicated, or host

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-vpc"
    Terraform   = "true"
    Environment = var.env_name
  }
}