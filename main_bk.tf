# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# # Configure the AWS Provider
# provider "aws" {
#   region = "ap-south-1"
# }

# # VPC 
# resource "aws_vpc" "vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name        = "vc-nonprod-vpc"
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# # Security Group EC2
# resource "aws_security_group" "vc_nonprod_ec2_sg" {
#   name_prefix = "vc-nonprod-ec2-sg"
#   description = "Non prod EC2 Security Group"
#   vpc_id      = aws_vpc.vpc.id

#   # Inbound rule: Allow TCP port 80 from the source security group vc_nonprod_lb_sg
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     security_groups = [aws_security_group.vc_nonprod_lb_sg.id]
#   }

#   # Inbound rule: Allow TCP port 443 from the source security group vc_nonprod_lb_sg
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     security_groups = [aws_security_group.vc_nonprod_lb_sg.id]
#   }

#   # Inbound rule: Allow TCP port from 3000 to 9900 from the source security group vc_nonprod_lb_sg
#     ingress {
#         from_port   = 3000
#         to_port     = 9900
#         protocol    = "tcp"
#         security_groups = [aws_security_group.vc_nonprod_lb_sg.id]
#     }

#   # Inbound rule: Allow TCP port from 1337 to 1337 from the source security group vc_nonprod_lb_sg
#   # File Upload Port for UAT
#     ingress {
#         from_port   = 1337
#         to_port     = 1337
#         protocol    = "tcp"
#         security_groups = [aws_security_group.vc_nonprod_lb_sg.id]
#     }

#   # Inbound rule: Allow TCP port from 2337 to 2337 from the source security group vc_nonprod_lb_sg
#   # File Upload Port for Staging
#     ingress {
#         from_port   = 2337
#         to_port     = 2337
#         protocol    = "tcp"
#         security_groups = [aws_security_group.vc_nonprod_lb_sg.id]
#     }

#   tags = {
#     Name        = "vc-nonprod-ec2-sg"
#     Terraform   = "true"
#     Environment = "Non Prod"
#   }
# }

# resource "aws_security_group" "vc_nonprod_lb_sg" {
#   name_prefix = "vc-nonprod-lb-sg"
#   description = "Non Prod Load Balancer Security Group"
#   vpc_id      = aws_vpc.vpc.id

#   # Inbound rule: Allow TCP port 443 from IPv4, 0.0.0.0/0
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Inbound rule: Allow TCP port 443 from IPv6, ::/0
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   # Inbound rule: Allow TCP port 80 from IPv4, 0.0.0.0/0
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Inbound rule: Allow TCP port 80 from IPv6, ::/0
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   # Add other inbound rules as needed for vc-nonprod_lb_sg

#   tags = {
#     Name        = "vc-nonprod-lb-sg"
#     Terraform   = "true"
#     Environment = "Non Prod"
#   }
# }



# # Subnet - Private
# resource "aws_subnet" "private" {
#   count = 3
#   cidr_block = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index)
#   vpc_id = aws_vpc.vpc.id
#   availability_zone = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)
#   tags = {
#     Name = "vc-nonprod-private-subnet-${count.index + 1}"
#   }
# }

# # Subnet - Public
# resource "aws_subnet" "public" {
#   count = 3
#   cidr_block = element(["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"], count.index)
#   vpc_id = aws_vpc.vpc.id
#   availability_zone = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)
#   tags = {
#     Name = "vc-nonprod-public-subnet-${count.index + 1}"
#   }
# }

# # Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id
#   tags = {
#     Name = "vc-nonprod-igw"
#   }
# }

# # Route Table - Public
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "vc-nonprod-public-rt"
#   }
# }

# # Route Table - Private 
# resource "aws_route_table" "private" {
#   count = 3
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "vc-nonprod-private-rt${count.index + 1}"
#   }
# }

# # Route Table Association - Public
# resource "aws_route_table_association" "public" {
#   count = 3
#   subnet_id = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# # Route Table Association - Private
# resource "aws_route_table_association" "private" {
#   count = 3
#   subnet_id = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private[count.index].id
# }

# # Instance resource
# resource "aws_instance" "vc-nonprod-instance" {
#   ami           = "ami-049a62eb90480f276"
#   instance_type = "m5a.large"
#     # subnet_id = module.vpc.public_subnets[0]
#     subnet_id     = aws_subnet.public[0].id
#     tags = {
#         Name = "vc-nonprod-instance"
#         Terraform = "true"
#         Environment = "non prod"
#     }
# }

# resource "aws_eip" "vc-nonprod-eip" {
#   instance = aws_instance.vc-nonprod-instance.id
#     domain      = "vpc"
#     tags = {
#         Name = "vc-nonprod-eip"
#         Terraform = "true"
#         Environment = "non prod"
#     }
# }