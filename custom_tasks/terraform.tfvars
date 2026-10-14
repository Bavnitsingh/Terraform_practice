aws_region = "ap-south-1"

tags = {
  Project   = "custom-tasks"
  ManagedBy = "terraform"
}

vpc_name             = "bsc-vpc"
vpc_cidr_block       = "10.0.0.0/16"
enable_dns_support   = true
enable_dns_hostnames = true
internet_cidr_block  = "0.0.0.0/0"
igw_name             = "bsc-igw"
nat_name             = "bsc-nat-007"
nat_subnet_key       = "public-1"
public_rt_name       = "bsc-public-rt"
private_rt_name      = "bsc-private-rt"

private_subnets = {
  "private-1" = { cidr_block = "10.0.11.0/24", availability_zone = "ap-south-1a" }
  "private-2" = { cidr_block = "10.0.12.0/24", availability_zone = "ap-south-1b" }
}
public_subnets = {
  "public-1" = { cidr_block = "10.0.1.0/24", availability_zone = "ap-south-1a" }
  "public-2" = { cidr_block = "10.0.2.0/24", availability_zone = "ap-south-1b" }
}

# ---- Security group ----
sg_name        = "bsc-web-sg"
sg_description = "Allow SSH and HTTP"

sg_ingress_rules = {
  ssh = {
    description = "SSH from my IP"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_ipv4   = "0.0.0.0/0"
  }
  http = {
    description = "HTTP from anywhere"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_ipv4   = "0.0.0.0/0"
  }
}

sg_egress_rules = {
  all = {
    description = "All outbound"
    protocol    = "-1"
    cidr_ipv4   = "0.0.0.0/0"
  }
}

# ---- EC2 ----
ec2_name                = "bsc-ec2"
ec2_instance_type       = "t3.micro"
ec2_ami_ssm_parameter   = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
ec2_subnet_key          = "public-1"
ec2_key_name            = "bsc-aws-prac-key"
ec2_associate_public_ip = true
ec2_imds_http_tokens    = "required"
ec2_root_volume_size    = 8
ec2_root_volume_type    = "gp3"