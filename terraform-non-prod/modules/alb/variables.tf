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
variable "instance_id" {
  type        = string
  description = "The instance ID"
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "The public subnet IDs"
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "The private subnet IDs"
}
variable "alb_sg_id" {
  type        = string
  description = "The security group id for the ALB"
}
variable "alb_name" {
  type        = string
  description = "The name of the ALB"
}
variable "certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate"
}

variable "target_groups" {
  type = list(object({
    name          = string
    instance_port = number
    path_patterns = list(string)
    host          = string
    lb_port       = number
    priority      = number
  }))
  description = "The target groups"
}