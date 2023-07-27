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
variable "ec2_access_role_name" {
  type = string
  description = "value of the ec2 access role name"
}