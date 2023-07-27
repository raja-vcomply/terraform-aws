# modules/security_groups/variables.tf

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
    type        = string
    description = "The VPC ID"
}
