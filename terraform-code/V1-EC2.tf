provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-04a37924ffe27da53"
    instance_type = "t2.micro
}
