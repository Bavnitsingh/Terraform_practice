variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = optional(number)
    to_port     = optional(number)
    cidr_ipv4   = string
  }))
}

variable "egress_rules" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = optional(number)
    to_port     = optional(number)
    cidr_ipv4   = string
  }))
}