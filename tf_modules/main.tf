provider "aws" {
  region = var.web_region
}

module "bsc-server-1" {
  source = ".//module-1"
}


module "bsc-server-2" {
  source = ".//module-2"
}