# modules/subnets/main.tf

# Create private subnets
resource "aws_subnet" "private" {
  count = 3
  cidr_block       = element(var.private_subnet_cidr_blocks, count.index)
  vpc_id           = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.global_prefix}-${var.env_name}-private-subnet-${count.index + 1}"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count = 3
  cidr_block       = element(var.public_subnet_cidr_blocks, count.index)
  vpc_id           = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.global_prefix}-${var.env_name}-public-subnet-${count.index + 1}"
  }
}
