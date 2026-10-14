

provider "aws" {
  region = "ap-south-1"
}

locals {
  environment = "staging"
}


resource "aws_vpc" "staging-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.environment}-vpc-tag"
  }
}
resource "aws_subnet" "staging-subnet" {
  vpc_id     = aws_vpc.staging-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "${local.environment}-subnet-tag"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}


resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.staging-subnet.id
  tags = {
    Name = "${local.environment} - TF ec2"
  }

}