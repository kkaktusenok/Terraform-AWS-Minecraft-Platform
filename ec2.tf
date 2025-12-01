# ec2.tf

# Последняя Ubuntu 22.04 в твоём регионе
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Сам сервер (пока в public подсети, потом перенесём в private)
resource "aws_instance" "minecraft" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.minecraft.key_name
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.minecraft.id
  ]

  tags = merge(local.tags, {
    Name = "${local.name}-server"
  })

  # Пока просто проверка, что заходит
  user_data = file("${path.module}/user-data/minecraft.sh")
}