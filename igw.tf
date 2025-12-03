resource "aws_internet_gateway" "mine_server_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "mine_server_igw"
  }
}