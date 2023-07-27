# modules/internet_gateway/main.tf

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-igw"
    Terraform   = "true"
    Environment = var.env_name
  }
}
