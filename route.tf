resource "aws_route_table" "mine_aws_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "minecraft-server-route_table"
  }
}

resource "aws_route" "mine_aws_route" {
  route_table_id         = aws_route_table.mine_aws_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mine_server_igw.id
}

resource "aws_route_table_association" "mine_server_aws_route_table_association" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.mine_aws_route_table.id
}