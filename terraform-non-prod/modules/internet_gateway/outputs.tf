# modules/internet_gateway/outputs.tf

# Define output values for the internet_gateway module.

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

# Add more outputs as needed for your specific internet_gateway configuration.
