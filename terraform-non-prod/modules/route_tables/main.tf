# modules/route_tables/main.tf



# Create the public route table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id  # Use 'internet_gateway_id' instead of 'igw.id'
  }

  # propagating_vgws = []  # Set to an empty list to designate it as the main route table

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-public-rt"
    Terraform   = "true"
    Environment = var.env_name
  }
}

# Create the private route table
resource "aws_route_table" "private" {
  # count  = 3
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-private-rt"
    Terraform   = "true"
    Environment = var.env_name
  }
}

# Associate the public route table with public subnets
resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Associate the private route table with private subnets
resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}

# Associate the main route table with the VPC
resource "aws_main_route_table_association" "main" {
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.public.id
}