#!/bin/bash
#  1. terraform init for DEV 

terraform init --var-file="dev.tfvars"

# 2. terraform plan for DEV 

terraform plan --var-file="dev.tfvars"

# 3. terraform apply for DEV 

terraform apply --var-file="dev.tfvars"

# 4. terraform destroy for DEV 

terraform destroy --var-file="dev.tfvars"