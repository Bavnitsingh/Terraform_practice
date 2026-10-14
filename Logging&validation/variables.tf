variable "instance_type" {
  description = "Instance type"
  type = string
default = "t3.micro"
validation {
  condition = can(regex("^[Tt][2-3].(nano|micro|small)",var.instance_type))
  error_message = "Invalid Instance type onlt allowed = t2.nano,t2.micro,t2.small or t3.nano,t3.small or t3.micro"
}
}