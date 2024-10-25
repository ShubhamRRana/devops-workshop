provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-04a37924ffe27da53"
  instance_type = "t2.micro"
  //security_groups = [ "demo-sg" ]
  vpc_security_group_ids = [ aws_security_group.demo-sg.id ]
  subnet_id = aws_subnet.demo-vpc-subnet-01.id
}



resource "aws_security_group" "demo-sg" {
  name        = "Workshop-SG"
  description = "Demo Security Group"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port     = 443
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "Workshop VPC"
  }
}

resource "aws_subnet" "demo-vpc-subnet-01" {
  vpc_id = aws_vpc.demo-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "demo-vpc-subnet-01"
  }
}

resource "aws_subnet" "demo-vpc-subnet-02" {
  vpc_id = aws_vpc.demo-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "demo-vpc-subnet-02"
  }
}

resource "aws_internet_gateway" "demo-ig" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "dmeo-igw"
  }
}

resource "aws_route_table" "demo-public-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-ig.id
  }
}

resource "aws_route_table_association" "demo-rta-public-subnet-01" {
  subnet_id = aws_subnet.demo-vpc-subnet-01.id
  route_table_id = aws_route_table.demo-public-rt.id
}

resource "aws_route_table_association" "demo-rta-public-subnet-02" {
  subnet_id = aws_subnet.demo-vpc-subnet-02.id
  route_table_id = aws_route_table.demo-public-rt.id
}