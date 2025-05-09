# Terraform Cloudflare Module

This Terraform module provides a comprehensive solution for managing Cloudflare resources. It's organized into submodules that can be enabled or disabled as needed.

## Features

- Account Authentication & Management
- DNS & Networking Configuration
- Security & Bot Management
- SSL/TLS Certificate Management
- Workers & KV Storage
- Zero Trust Security
- Pages & Content Delivery
- R2 Storage Management

## Usage

```hcl
module "cloudflare" {
  source = "git::https://github.com/username/terraform-cloudflare.git?ref=v1.0.0"

  cloudflare_api_token = var.cloudflare_api_token
  account_id          = var.account_id
  environment         = "production"

  # Enable/disable specific modules
  enabled_modules = {
    account_authentication  = true
    dns_networking         = true
    security_bot_management = false
    ssl_tls_certificates   = true
    workers               = false
    zero_trust_security   = true
    pages_delivery       = false
    r2_storage          = true
  }

  # Module-specific configurations
  account_auth_config = {
    name = "My Cloudflare Account"
    type = "standard"
    api_tokens = [
      {
        name = "terraform-token"
        permissions = ["DNS Write", "Zone Write"]
      }
    ]
  }

  dns_networking_config = {
    zones = [
      {
        name = "example.com"
        plan = "free"
      }
    ]
    records = [
      {
        zone_name = "example.com"
        name      = "www"
        type      = "A"
        value     = "192.0.2.1"
        proxied   = true
      }
    ]
  }
}
```

## Requirements

- Terraform >= 1.0.0
- Cloudflare Provider >= 5.4.0

## Modules

### Account Authentication (`account_authentication`)
Manages Cloudflare account settings, API tokens, and member access.

### DNS Networking (`dns_networking`)
Handles DNS zones, records, and network configurations.

### Security Bot Management (`security_bot_management`)
Manages firewall rules, bot protection, and security settings.

### SSL/TLS Certificates (`ssl_tls_certificates`)
Handles SSL/TLS certificates and custom hostname configurations.

### Workers (`workers`)
Manages Cloudflare Workers, KV storage, and routing.

### Zero Trust Security (`zero_trust_security`)
Configures Zero Trust access policies, applications, and tunnels.

### Pages Delivery (`pages_delivery`)
Manages Cloudflare Pages projects and custom domains.

### R2 Storage (`r2_storage`)
Handles R2 bucket creation and configuration.

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| cloudflare_api_token | API token for authentication | string | yes | - |
| account_id | Cloudflare account ID | string | yes | - |
| environment | Environment name | string | no | "production" |
| enabled_modules | Map of modules to enable/disable | map(bool) | no | All true |
| tags | Resource tags | map(string) | no | {} |

## Outputs

| Name | Description |
|------|-------------|
| account_auth | Account authentication outputs |
| dns_networking | DNS and networking outputs |
| security_bot | Security and bot management outputs |
| ssl_tls | SSL/TLS certificate outputs |
| workers | Workers configuration outputs |
| zero_trust | Zero Trust security outputs |
| pages_delivery | Pages delivery outputs |
| r2_storage | R2 storage outputs |

## Example Configurations

### Basic DNS Management
```hcl
module "cloudflare" {
  source = "git::https://github.com/username/terraform-cloudflare.git?ref=v1.0.0"

  cloudflare_api_token = var.cloudflare_api_token
  account_id          = var.account_id

  enabled_modules = {
    dns_networking = true
  }

  dns_networking_config = {
    zones = [{
      name = "example.com"
      plan = "free"
    }]
    records = [{
      zone_name = "example.com"
      name      = "www"
      type      = "A"
      value     = "192.0.2.1"
      proxied   = true
    }]
  }
}
```

### Zero Trust Security Setup
```hcl
module "cloudflare" {
  source = "git::https://github.com/username/terraform-cloudflare.git?ref=v1.0.0"

  cloudflare_api_token = var.cloudflare_api_token
  account_id          = var.account_id

  enabled_modules = {
    zero_trust_security = true
  }

  zero_trust_config = {
    applications = [{
      name   = "internal-app"
      domain = "app.example.com"
      type   = "self_hosted"
    }]
    policies = [{
      name = "allow-internal"
      application_id = "app_id"
      decision      = "allow"
      include = {
        group = ["internal-users"]
      }
    }]
  }
}
```

## Development

To contribute to this module:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

This module is licensed under the MIT License. See the LICENSE file for details.
