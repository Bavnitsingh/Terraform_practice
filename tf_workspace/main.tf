terraform {
  required_version = ">=1.0"
}

locals {
  instance_name = "${terraform.workspace}-instance"
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
  instance_type               = var.instance_type
  key_name = "bsc-key-pair"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.main.id]
  tags =  {
    Name = local.instance_name
  }


}

resource "aws_security_group" "main" {
    name        = "bsc-ssh-and-http"
  description = "Allow SSH and HTTP"
    egress = [ 
        {
            from_port = 0
            description = ""
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = [ ]
            self = false
            security_groups = []

        }
     ]  

    ingress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids = [  ]
      self = false
      description = ""
            security_groups = []

    },
    {
        cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
      from_port = 80
      to_port = 80
      protocol = "tcp"
     security_groups = []

      ipv6_cidr_blocks = []
      prefix_list_ids = [  ]
      self = false
      description = ""
    }
    
    ]

   
}