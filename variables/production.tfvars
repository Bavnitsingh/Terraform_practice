instance_count   = 2
instance_type    = "t3.micro"
enable_public_ip = true
user_names       = ["bsc", "hsc"]
project_env = {
  "name" = "bsc-tf-ec2"
  "environment" = "production"
}