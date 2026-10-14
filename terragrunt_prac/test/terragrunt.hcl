terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=6.0.0"
}

locals {
  instance_type = "t3.micro"
}

inputs = {
  name          = "terragrunt-tutorial-ec2"
  instance_type = local.instance_type
  subnet_id = "subnet-06de01a294a6a62a2"

  # Resolves the latest Ubuntu 24.04 AMI at plan time; no data block needed.
  ami_ssm_parameter = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"

  tags = {
    Name = "test - Terragrunt Tutorial EC2"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}
EOF
}