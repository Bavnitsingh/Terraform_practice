variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_ssm_parameter" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type    = string
  default = null
}

variable "associate_public_ip_address" {
  type = bool
}

variable "imds_http_tokens" {
  description = "Set to \"required\" to enforce IMDSv2"
  type        = string
}

variable "root_volume_size" {
  type = number
}

variable "root_volume_type" {
  type = string
}