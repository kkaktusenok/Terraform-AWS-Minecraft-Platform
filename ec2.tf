# ec2.tf

# Последняя Ubuntu 22.04 в твоём регионе
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Сам сервер (пока в public подсети, потом перенесём в private)
resource "aws_instance" "minecraft" {
  ami                         = "ami-073547175b8ce1fd9" #data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.minecraft.key_name
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.minecraft.id
  ]

  tags = merge(local.tags, {
    Name = "${local.name}-server"
  })
}