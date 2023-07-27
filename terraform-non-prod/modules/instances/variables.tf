# modules/instances/variables.tf

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

# The value will come from the main.tf, also which is coming form root variables.tf
variable "instance_type" {
  type    = string
  # default = "m5a.large"
  description = "value of the instance type"
}

# The value will come from the main.tf, also which is coming form root variables.tf
variable "ami" {
  type    = string
  # default = "ami-049a62eb90480f276"
  description = "value of the ami"
}

# The value will come from the main.tf, also which is coming form root variables.tf
variable "root_block_device_volume_size" {
  type    = number
  # default = 100
  description = "value of the root block device volume size"  
}

variable "ec2_sg_id" {
  type = string
  description = "value of the security group id"
}

variable "ec2_access_role_name" {
  type = string
  description = "value of the ec2 access role name"
}

variable "key_name" {
  type = string
  description = "value of the key name"
}