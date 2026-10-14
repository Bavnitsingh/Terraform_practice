#!/bin/bash
#  1. terraform init for production 

terraform init --var-file="production.tfvars"

# 2. terraform plan for production 

terraform plan --var-file="production.tfvars"

# 3. terraform apply for DEV 

terraform apply --var-file="production.tfvars"

# 4. terraform destroy for production 

terraform destroy --var-file="production.tfvars"