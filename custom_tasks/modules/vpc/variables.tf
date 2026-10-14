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
  description = "Destination CIDR for default routes"
  type        = string
}

variable "igw_name" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "nat_subnet_key" {
  description = "Key of the public subnet that hosts the NAT gateway"
  type        = string
}

variable "public_rt_name" {
  type = string
}

variable "private_rt_name" {
  type = string
}