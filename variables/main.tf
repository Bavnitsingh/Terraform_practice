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
  instance_type               = var.instance_type
  count                       = var.instance_count
  associate_public_ip_address = var.enable_public_ip
  tags = merge(var.project_env, {
    Name = "${var.project_env["name"]}-${count.index + 1}"
  })

}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}


data "aws_subnet" "selected" {
  count = var.instance_count
  id    = aws_instance.ec2_from_terraform[count.index].subnet_id
}

# output "ami_id_used" {
#   value = aws_instance.ec2_from_terraform[*].ami
# }



output "instance_ids" {
  value = aws_instance.ec2_from_terraform[*].id
}

output "public_ip" {
  value = aws_instance.ec2_from_terraform[*].public_ip
}

# output "private_ip" {
#   value = aws_instance.ec2_from_terraform[*].private_ip
# }


output "iam_users" {
  value = aws_iam_user.example[*].name
}

# output "vpc_ids" {
#   value = data.aws_subnet.selected[*].vpc_id
# }
