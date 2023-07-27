# modules/vpc/outputs.tf

# Define output values for the VPC module.

output "vpc_id" {
  value = aws_vpc.vpc.id
}

# Add more outputs as needed for your specific VPC configuration.
