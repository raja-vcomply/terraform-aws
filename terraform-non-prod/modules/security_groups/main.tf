# modules/security_groups/main.tf

# Create the EC2 security group
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.global_prefix}-${var.env_name}-ec2-sg"
  description = "${var.env_name} EC2 Security Group"
  vpc_id      = var.vpc_id

  # Inbound rule: Allow TCP port 80 from the source security group lb_sg
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  # Inbound rule: Allow TCP port 443 from the source security group lb_sg
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  # Inbound rule: Allow TCP port from 3000 to 9900 from the source security group lb_sg
  ingress {
    from_port       = 3000
    to_port         = 9900
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
 
  # Inbound rule: Allow TCP port from 1337 to 1337 from the source security group lb_sg
  # File Upload Port for UAT
  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  # Inbound rule: Allow TCP port from 2337 to 2337 from the source security group lb_sg
  # File Upload Port for Staging
  ingress {
    from_port       = 2337
    to_port         = 2337
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

# Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-ec2-sg"
    Terraform   = "true"
    Environment = var.env_name
  }
}

# Create the load balancer security group
resource "aws_security_group" "lb_sg" {
  name_prefix = "${var.global_prefix}-${var.env_name}-lb-sg"
  description = "${var.env_name} Load Balancer Security Group"
  vpc_id      = var.vpc_id

  # Inbound rule: Allow TCP port 443 from IPv4, 0.0.0.0/0
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # Inbound rule: Allow TCP port 443 from IPv6, ::/0
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  # Inbound rule: Allow TCP port 80 from IPv4, 0.0.0.0/0
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # Inbound rule: Allow TCP port 80 from IPv6, ::/0
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add other inbound rules as needed for lb_sg

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-lb-sg"
    Terraform   = "true"
    Environment = var.env_name
  }
}
