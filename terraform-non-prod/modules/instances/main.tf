# This is the main configuration file for the instances module.
# Define your instance resources here.
# modules/instances/main.tf

variable "public_subnet_ids" {}

resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0]
  associate_public_ip_address = true
  monitoring = true

  # Add role to instance
  iam_instance_profile = var.ec2_access_role_name

  # Add SSH key to instance
  key_name = var.key_name

  # Attach the security group to the instance
  vpc_security_group_ids = [var.ec2_sg_id]


  root_block_device {
    volume_size = var.root_block_device_volume_size # in GB <<----- I increased this!
    volume_type = "gp3"
    encrypted   = false
    # kms_key_id  = data.aws_kms_key.customer_master_key.arn
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-instance"
    Terraform   = "true"
    Environment = var.env_name
  }
  volume_tags = {
    Name        = "${var.global_prefix}-${var.env_name}-instance-volume"
    Terraform   = "true"
    Environment = var.env_name
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.instance.id
  # domain   = "vpc"

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-eip"
    Terraform   = "true"
    Environment = var.env_name
  }
}
