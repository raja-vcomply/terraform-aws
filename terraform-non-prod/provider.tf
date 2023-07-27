terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = "CHANGE ME"
  secret_key = "CHANGE ME"
}


# terraform init -provider=provider.tf