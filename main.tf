provider "aws" {
  # Configuration options
  region = "us-west-1"
  profile = "dandev"
}



data "aws_ami" "ubuntu"{
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "app_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.mine_subnet.id

  tags = {
    Name = "mine-terraform_instance"
  }
  
}

resource "aws_vpc" "mine_aws_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Minecraft-VPC"
  }
}

resource "aws_subnet" "mine_subnet" {
  vpc_id = aws_vpc.mine_aws_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main subnet"
  }
}


resource "aws_internet_gateway" "mine_gw" {
  vpc_id = aws_vpc.mine_aws_vpc.id
  tags = {
    Name = "Mine Internet Gateway"
  }
  
}

resource "aws_route_table" "mine_rout_table" {
  vpc_id = aws_vpc.mine_aws_vpc.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_internet_gateway.mine_gw.id
  } 
}

resource "aws_route_table_association" "mine_route_table_association" {
  subnet_id = aws_subnet.mine_subnet.id
  route_table_id = aws_route_table.mine_rout_table.id
}