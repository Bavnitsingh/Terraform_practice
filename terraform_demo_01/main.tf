provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name= "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
    filter {
      name = "architecture"
      values = ["x86_64"]
    }
    
}



resource "aws_instance" "ec2_from_terraform" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    tags = {
      Name = "Terraform Ec2"
    }
  
}

data "aws_subnet" "selected" {
    id = aws_instance.ec2_from_terraform.subnet_id
}

output "ami_id_used" {
  value = aws_instance.ec2_from_terraform.ami
}



output "instance_id" { 
    value = aws_instance.ec2_from_terraform.id 
}

output "public_ip" {
    value = aws_instance.ec2_from_terraform.public_ip
}

output "private_ip" {
    value = aws_instance.ec2_from_terraform.private_ip
}