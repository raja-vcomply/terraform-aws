# VPC module
module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block # The value will come from the root variables.tf
  env_name       = var.env_name       # The value will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
}

# Keys module
module "keys" {
  source             = "./modules/keys"
  generated_key_name = local.ec2_key_name # The value of var will come from the root variables.tf
  env_name           = var.env_name     # The value of var will come from the root variables.tf
  global_prefix      = var.global_prefix  # The value will come from the root variables.tf
}

# Security Groups module
module "security_groups" {
  source     = "./modules/security_groups"
  depends_on = [module.vpc]

  env_name = var.env_name # The value of var will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
  vpc_id = module.vpc.vpc_id
}

# Subnets module
module "subnets" {
  source     = "./modules/subnets"
  depends_on = [module.vpc]

  env_name                   = var.env_name                   # The value of var will come from the root variables.tf
  global_prefix              = var.global_prefix  # The value will come from the root variables.tf
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks # The value of var will come from the root variables.tf
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks  # The value of var will come from the root variables.tf
  availability_zones         = var.availability_zones         # The value of var will come from the root variables.tf
  vpc_id                     = module.vpc.vpc_id
}

# Route Tables module
module "internet_gateway" {
  source     = "./modules/internet_gateway"
  depends_on = [module.vpc]
  env_name   = var.env_name # The value of var will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
  vpc_id = module.vpc.vpc_id
}

# Route Tables module
module "route_tables" {
  source     = "./modules/route_tables"
  depends_on = [module.vpc, module.subnets, module.internet_gateway]

  env_name            = var.env_name           # The value of var will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  internet_gateway_id = module.internet_gateway.internet_gateway_id

}

# IAM module
module "iam" {
  source               = "./modules/iam"
  ec2_access_role_name = local.ec2_access_role_name # The value of var will come from the root variables.tf
  env_name             = var.env_name             # The value of var will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
  # vpc_id = module.vpc.vpc_id
}

# Instances module
module "instances" {
  source     = "./modules/instances"
  depends_on = [module.vpc, module.iam, module.keys, module.subnets, module.security_groups]

  env_name      = var.env_name      # The value of var will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
  instance_type = var.instance_type # The value of var will come from the root variables.tf
  ami           = var.ami           # The value of var will come from the root variables.tf
  # vpc_id = module.vpc.vpc_id
  ec2_access_role_name = module.iam.ec2_access_role_name
  key_name             = module.keys.key_name

  root_block_device_volume_size = var.root_block_device_volume_size # The value of var will come from the root variables.tf
  ec2_sg_id          = module.security_groups.ec2_sg_id
  public_subnet_ids             = module.subnets.public_subnet_ids
}

# ACM module
module "acm" {
  source     = "./modules/acm"

  env_name      = var.env_name      # The value of var will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
  domain_name = var.acm_domain_name # The value of var will come from the root variables.tf
  domain_zone = var.acm_domain_zone # The value of var will come from the root variables.tf
} 

# Application Load Balancer - ALB module
module "alb" {
  source     = "./modules/alb"
  depends_on = [module.vpc, module.subnets, module.security_groups, module.instances, module.acm]
  env_name           = var.env_name # The value of var will come from the root variables.tf
  global_prefix  = var.global_prefix  # The value will come from the root variables.tf
  target_groups      = var.target_groups # The value of var will come from the root variables.tf
  
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  alb_sg_id          = module.security_groups.lb_sg
  instance_id        = module.instances.instance_id
  alb_name           = local.alb_name # The value of var will come from the root variables.tf
  certificate_arn    = module.acm.certificate_arn
}


# ===================================================================================
# ---------------------------------- OUTPUTS ----------------------------------------
# ===================================================================================
# Output the VPC ID
output "vpc_id" {
  value = module.vpc.vpc_id
}

# # Output the Subnet IDs
# output "subnet_ids" {
#   value = module.subnets.subnet_ids
# }
# Output the public Subnet IDs
output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}
# Output the Private Subnet IDs
output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  value = module.internet_gateway.internet_gateway_id
}
# Output any other resources you want to expose as outputs
# For example, you can output the IDs of instances, subnets, etc.
# ===================================================================================
# ---------------------------------- OUTPUTS ----------------------------------------
# ===================================================================================