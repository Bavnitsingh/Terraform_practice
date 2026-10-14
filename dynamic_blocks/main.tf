provider "aws" {
  region = "ap-south-1"
}

locals {
    ingress_rules = [{
        port = 443
        description = "Ingress rules for 443(https)"

    },
    {
        port = 22
        description = "Ingress rules for port 22(ssh)"
    }
    ]
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
resource "aws_instance" "ec2_from_terraform" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name = "bsc-key-pair"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.main.id]
  tags =  {
    Name = "Bsc-ec2-tf-prac"
  }

}


resource "aws_security_group" "main" {
  name        = "bsc-ssh-sg"
  description = "Allow SSH and HTTPS"
 dynamic "ingress" {
   for_each = local.ingress_rules
   content {
     description = ingress.value.description
     from_port = ingress.value.port
     to_port = ingress.value.port
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 }

egress {
    from_port   = 0
    to_port     = 0
    self = false
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 

 
 
}

output "public_ip" {
  value = aws_instance.ec2_from_terraform.public_ip
}
