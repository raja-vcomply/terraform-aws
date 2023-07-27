# modules/subnets/outputs.tf

# Define output values for the subnets module.

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

# Add more outputs as needed for your specific subnets configuration.
