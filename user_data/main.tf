provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "example" {
  ami = "ami-065d2b03fb493085a"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name = "bsc-aws-prac-key"
  # user_data = <<EOF
  # 
  # echo "Hello World!!" > hello.txt
  # EOF

  user_data = "${file("install_apache.sh")}"
}

resource "aws_security_group" "main" {
  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = ""
    ipv6_cidr_blocks = [  ]
    protocol = "-1"
    security_groups = [  ]
    self = false
    to_port = 0
    from_port = 0
    prefix_list_ids = []
  } ]
  ingress = [ {
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
    from_port = 22
    ipv6_cidr_blocks = []
    to_port = 22
    protocol = "tcp"
    security_groups = []
    self = false
    prefix_list_ids = []
  },
      {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    }
   ]
}
# output "fetched_info_from_aws" {
#   value = format("%s%s","ssh -i /Users/rahulwagh/.ssh/aws_ec2_terraform ubuntu@",aws_instance.example.public_dns)
# }