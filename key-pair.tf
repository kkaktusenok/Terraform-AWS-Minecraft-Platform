resource "tls_private_key" "minecraft" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.minecraft.private_key_pem
  filename        = pathexpand("~/.ssh/${local.name}.pem")
  file_permission = "0400"
}

resource "aws_key_pair" "minecraft" {
  key_name   = local.name
  public_key = tls_private_key.minecraft.public_key_openssh
}