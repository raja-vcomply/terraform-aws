# modules/vpc/variables.tf

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
variable "vpc_cidr_block" {
  type = string
  # default = "10.0.0.0/16"
  description = "value of the vpc cidr block"
}
