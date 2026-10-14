variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "enable_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = true
}

variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["bavnit", "singh"]
}

variable "project_env" {
  description = "Project name and environment tags"
  type        = map(string)
  default = {
    "name" : "bsc01instance"
  }
}
