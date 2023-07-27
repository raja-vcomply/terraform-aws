# modules/subnets/variables.tf

variable "env_name" {
  type    = string
  # default = "non-prod"
  description = "The environment name"
}
variable "global_prefix" {
  type = string
  # default = "vc"
  description = "The global prefix"
}
variable "vpc_id" {
  type = string
  description = "value of the vpc id"
}

# The value will come from the main.tf, also which is coming form root variables.tf
variable "private_subnet_cidr_blocks" {
  type = list(string)
  # default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "value of the private subnet cidr blocks"
}

# The value will come from the main.tf, also which is coming form root variables.tf
variable "public_subnet_cidr_blocks" {
  type = list(string)
  # default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "value of the public subnet cidr blocks"
}

# The value will come from the main.tf, also which is coming form root variables.tf
variable "availability_zones" {
  type = list(string)
  # default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  description = "value of the availability zones"
}