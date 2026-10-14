module "vpc" {
  source = "./modules/vpc"

  vpc_name             = var.vpc_name
  vpc_cidr_block       = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  internet_cidr_block  = var.internet_cidr_block
  igw_name             = var.igw_name
  nat_name             = var.nat_name
  nat_subnet_key       = var.nat_subnet_key
  public_rt_name       = var.public_rt_name
  private_rt_name      = var.private_rt_name
}

module "security_groups" {
  source = "./modules/sg"

  sg_name        = var.sg_name
  sg_description = var.sg_description
  vpc_id         = module.vpc.vpc_id
  ingress_rules  = var.sg_ingress_rules
  egress_rules   = var.sg_egress_rules
}

module "ec2_instance" {
  source = "./modules/ec2"

  instance_name               = var.ec2_name
  instance_type               = var.ec2_instance_type
  ami_ssm_parameter           = var.ec2_ami_ssm_parameter
  subnet_id                   = module.vpc.public_subnet_ids[var.ec2_subnet_key]
  security_group_ids          = [module.security_groups.security_group_id]
  key_name                    = var.ec2_key_name
  associate_public_ip_address = var.ec2_associate_public_ip
  imds_http_tokens            = var.ec2_imds_http_tokens
  root_volume_size            = var.ec2_root_volume_size
  root_volume_type            = var.ec2_root_volume_type
}