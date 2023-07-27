# modules/security_groups/outputs.tf

# Define output values for the security_groups module.

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "lb_sg" {
  value = aws_security_group.lb_sg.id
}

# Add more outputs as needed for your specific security_groups configuration.
