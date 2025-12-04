# making statick elastick IP
resource "aws_eip" "mine_aws_eip" {
  tags = {
    Name = "minecraft-server-eip"
  }
}

resource "aws_eip_association" "mine_aws_eip_association" {
  instance_id   = aws_instance.minecraft.id
  allocation_id = aws_eip.mine_aws_eip.id
}