variable "aws_region" {
  type = string
}

variable "tags" {
  type = map(string)
}

# ---- VPC ----
variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "internet_cidr_block" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "nat_subnet_key" {
  type = string
}

variable "public_rt_name" {
  type = string
}

variable "private_rt_name" {
  type = string
}

# ---- Security group ----
variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "sg_ingress_rules" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = optional(number)
    to_port     = optional(number)
    cidr_ipv4   = string
  }))
}

variable "sg_egress_rules" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = optional(number)
    to_port     = optional(number)
    cidr_ipv4   = string
  }))
}

# ---- EC2 ----
variable "ec2_name" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "ec2_ami_ssm_parameter" {
  type = string
}

variable "ec2_subnet_key" {
  description = "Key from public_subnets where the instance is placed"
  type        = string
}

variable "ec2_key_name" {
  type    = string
  default = null
}

variable "ec2_associate_public_ip" {
  type = bool
}

variable "ec2_imds_http_tokens" {
  type = string
}

variable "ec2_root_volume_size" {
  type = number
}

variable "ec2_root_volume_type" {
  type = string
}