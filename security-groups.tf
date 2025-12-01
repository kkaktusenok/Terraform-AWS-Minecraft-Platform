# security-groups.tf

# Используем специальный эндпоинт, который отдаёт ТОЛЬКО IP (без HTML)
data "http" "myip" {
  url = "https://ifconfig.me/ip" # ← вот эта стовая магия
  # альтернативы на случай, если и этот сломается:
  # url = "https://api.ipify.org"
  # url = "https://checkip.amazonaws.com"
}

resource "aws_security_group" "ssh" {
  name   = "${local.name}-ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # chomp убирает \n в конце, теперь точно чистый IP
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    description = "SSH only from my current IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${local.name}-sg-ssh" })
}

resource "aws_security_group" "minecraft" {
  name   = "${local.name}-minecraft"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # потом заменишь на Cloudflare или свой IP
    description = "Minecraft port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${local.name}-sg-minecraft" })
}