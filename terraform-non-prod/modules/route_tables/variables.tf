# modules/route_tables/variables.tf

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
variable "public_subnet_ids" {
    type        = list(string)
    description = "The public subnet IDs"
}
variable "private_subnet_ids" {
    type        = list(string)
    description = "The private subnet IDs"
}
variable "internet_gateway_id" {
    type        = string
    description = "The internet gateway ID"
}
