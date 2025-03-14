resource "tls_private_key" "my_rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key-name
  public_key = tls_private_key.my_rsa_key.public_key_openssh
}

resource "local_file" "my_private_key" {
  content  = tls_private_key.my_rsa_key.private_key_pem
  filename = var.private-key-file
}