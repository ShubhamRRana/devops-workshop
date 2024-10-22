provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-04a37924ffe27da53"
  instance_type = "t2.micro"
  security_groups = [ "demo-sg" ]
}



resource "aws_security_group" "demo-sg" {
  description = "Demo Security Group"
  name        = "Workshop-SG"
  ingress {
    to_port     = 22
    from_port   = 22
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