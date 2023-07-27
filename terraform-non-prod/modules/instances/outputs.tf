# modules/instances/outputs.tf

# Define output values for the instances module.

output "instance_id" {
  value = aws_instance.instance.id
}

output "public_ip" {
  value = aws_eip.eip.public_ip
}

# Add more outputs as needed for your specific instances configuration.
