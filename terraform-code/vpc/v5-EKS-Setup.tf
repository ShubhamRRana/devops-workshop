provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t2.micro"
    key_name = "WorkshopKP"
    # security_groups = [ "demo-sg" ]
    vpc_security_group_ids = [ aws_security_group.demo-sg.id ]
    subnet_id = aws_subnet.demo-public-subnet-01.id
    for_each = toset(["Jenkins-master", "Build-slave", "Ansible"])
    tags = {
      Name = "${each.key}"
    }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.demo-vpc.id 
  
  ingress {
    description      = "Shh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  
  ingress {
    description      = "Jenkins port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
  
}

resource "aws_subnet" "demo-public-subnet-01" {
  vpc_id = aws_vpc.demo-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "demo-public-subent-01"
  }
}

resource "aws_subnet" "demo-public-subnet-02" {
  vpc_id = aws_vpc.demo-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "demo-public-subent-02"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id 
  tags = {
    Name = "demo-igw"
  } 
}

resource "aws_route_table" "demo-public-rt" {
  vpc_id = aws_vpc.demo-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id 
  }
}

resource "aws_route_table_association" "demo-rta-public-subnet-01" {
  subnet_id = aws_subnet.demo-public-subnet-01.id
  route_table_id = aws_route_table.demo-public-rt.id   
}

resource "aws_route_table_association" "demo-rta-public-subnet-02" {
  subnet_id = aws_subnet.demo-public-subnet-02.id 
  route_table_id = aws_route_table.demo-public-rt.id   
}

module "sgs"{
  source = "../sg_eks"
  vpc_id = aws_vpc.demo-vpc.vpc_id
}

module "eks" {
  source = "../eks"
  vpc_id = aws_vpc.demo-vpc.id
  subnet_ids = [aws_subnet.demo-public-subnet-01.id, aws_subnet.demo-public-subnet-02.id]
  sg_ids = module.sgs.security_group_public
}