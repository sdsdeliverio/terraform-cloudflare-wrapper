# Terraform Cloudflare Module

This Terraform module manages Cloudflare resources and authentication. It can be used as a remote module in other Terraform configurations.

## Usage

```hcl
module "cloudflare" {
  source = "git::https://github.com/your-username/terraform-cloudflare.git?ref=v1.0.0"

  cloudflare_api_token = var.cloudflare_api_token
  module_enabled      = true
  module_tags        = {
    environment = "production"
    managed_by  = "terraform"
  }
}

module "cloudflare_auth" {
  source = "git::https://github.com/your-username/terraform-cloudflare.git//modules/account_authentication?ref=v1.0.0"

  account_name   = "My Cloudflare Account"
  api_token_name = "terraform-managed-token"
  enforce_2fa    = true
  
  account_members = [
    {
      email = "user@example.com"
      roles = ["Administrator"]
    }
  ]
}
```

## Requirements

- Terraform >= 1.0.0
- Cloudflare Provider >= 4.0.0

## Module Structure

```plaintext
terraform-cloudflare/
├── README.md
├── provider.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── modules/
│   ├── account_authentication/
│   ├── dns_networking/
│   ├── security_bot_management/
│   ├── ssl_tls_certificates/
│   ├── workers/
│   ├── zero_trust_security/
│   ├── pages_delivery/
│   └── r2_storage/
└── examples/
    └── complete/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| cloudflare_api_token | The API token for Cloudflare authentication | string | yes | - |
| module_enabled | Whether to create the module's resources | bool | no | true |
| module_tags | A map of tags to add to all resources | map(string) | no | {} |

## Outputs

| Name | Description |
|------|-------------|
| module_enabled | Whether the module is enabled |
| module_tags | Tags applied to the module's resources |

## Versioning

This module follows [Semantic Versioning](https://semver.org/). For the versions available, see the tags on this repository.

## Authors

Your Name (@your-github-username)

## License

MIT
