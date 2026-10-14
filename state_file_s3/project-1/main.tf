terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # match what's in your .terraform.lock.hcl
    }
  }

  backend "s3" {
    bucket       = "bsc-state-tf-bucket"
    key          = "bsc/terraform/remote/s3/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true # S3-native locking; no DynamoDB needed
    encrypt      = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR form, e.g. 203.0.113.10/32"
  type        = string
}

locals {
  ingress_rules = [
    {
      port        = 443
      description = "HTTPS"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 22
      description = "SSH from my IP only"
      cidr_blocks = [var.my_ip_cidr]
    }
  ]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "main" {
  name_prefix = "bsc-ssh-sg-"
  description = "Allow SSH (restricted) and HTTPS"

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "ec2_from_terraform" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = "bsc-aws-prac-key"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.main.id]

  metadata_options {
    http_tokens = "required" # enforce IMDSv2
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "Bsc-ec2-tf-prac"
  }
}

output "public_ip" {
  value = aws_instance.ec2_from_terraform.public_ip
}