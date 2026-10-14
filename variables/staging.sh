#!/bin/bash
#  1. terraform init for staging 

terraform init --var-file="staging.tfvars"

# 2. terraform plan for staging 

terraform plan --var-file="staging.tfvars"

# 3. terraform apply for staging 

terraform apply --var-file="staging.tfvars"

# 4. terraform destroy for staging 

terraform destroy --var-file="staging.tfvars"