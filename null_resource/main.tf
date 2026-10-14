provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "ec2_example" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  tags = {
    name = "Bavnit Singh ec2 tf"
  }
}

resource "null_resource" "null_res" {

  triggers = {
    # id = aws_instance.ec2_example.id 
     id = timestamp() #new id so this will run again

  }
  provisioner "local-exec" {
    command = "echo Hello world"
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

variable "instance_type" {
  description = "Type of Instance"
  type = string
  default = "t3.micro"
}