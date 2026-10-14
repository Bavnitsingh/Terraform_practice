provider "aws" {
  region = "ap-south-1"
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

provisioner "local-exec"{
  command = "touch hello.txt"
}

provisioner "remote-exec"{
  inline = [
    "touch hello.txt",
    "echo helloworld remote provisioner >> hello.txt"
  ]
}

  provisioner "file" {
source = "/home/bavnit-chabada/input.txt"
destination = "/home/ubuntu/test-file.txt"
}

connection {
  type = "ssh"
  host = self.public_ip
  user = "ubuntu"
  private_key = file("/home/bavnit-chabada/Downloads/bsc-key-pair.pem")
  timeout     = "4m"
}
}


resource "aws_security_group" "main" {
  name        = "bsc-ssh-sg"
  description = "Allow SSH"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.ec2_from_terraform.public_ip
}
