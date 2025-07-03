# /bin/bash
# This script is used to initialize, plan, and apply changes to the Terraform configuration. To setup a local development environment, run the following commands:
# 1. first we need to set the environment variables for the Terraform configuration. Secrets
# 2. then we can run the script to initialize, plan, and apply changes to the Terraform configuration.

# Set the environment variables for the Terraform configuration. Secrets
export TF_VAR_cloudflare_api_token=your_cloudflare_api_token
export TF_VAR_cloudflare_account_id=your_cloudflare_account_id
export TF_VAR_cloudflare_zone_id=your_cloudflare_zone_id
# Setup backend AWS S3 bucket

# 1. Initialize Terraform
terraform init

# 2. Plan the changes
terraform plan 

# Apply the changes
terraform apply