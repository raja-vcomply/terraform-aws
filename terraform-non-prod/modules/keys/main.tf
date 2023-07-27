

resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh
}

provider "local" {
  # Use the local provider to generate the .pem file
}

resource "local_file" "generated_pem" {
  content  = tls_private_key.dev_key.private_key_pem
  filename = "./modules/keys/.pem/${var.generated_key_name}.pem"
}
