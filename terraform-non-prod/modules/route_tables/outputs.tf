# modules/route_tables/outputs.tf

# Define output values for the route_tables module.

output "public_route_table_ids" {
  value = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

# Add more outputs as needed for your specific route_tables configuration.
