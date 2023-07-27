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
variable "domain_name" {
  description = "The domain name for which the certificate should be issued."
  type        = string
#   default     = "*.us.app.v-comply.com" # Change this to your domain name
}

variable "domain_zone" {
  description = "The domain zone for which the certificate should be issued."
  type        = string
#   default     = "us.app.v-comply.com" # Change this to your domain zone
}
