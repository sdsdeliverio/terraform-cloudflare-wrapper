# Terraform Cloudflare Wrapper Module

[![Terraform PR Checks](https://github.com/sdsdeliverio/terraform-cloudflare-wrapper/actions/workflows/terraform-pr-checks.yml/badge.svg)](https://github.com/sdsdeliverio/terraform-cloudflare-wrapper/actions/workflows/terraform-pr-checks.yml)
[![Terraform Tests](https://github.com/sdsdeliverio/terraform-cloudflare-wrapper/actions/workflows/terraform-tests.yml/badge.svg)](https://github.com/sdsdeliverio/terraform-cloudflare-wrapper/actions/workflows/terraform-tests.yml)

A comprehensive Terraform module for managing Cloudflare resources with a modular, clean architecture.

## Architecture

This module follows Terraform best practices:

- **Provider configuration at root**: No provider blocks in child modules
- **Modular design**: Each feature area (DNS, Email, Zero Trust) is a separate module
- **Flexible enablement**: Enable/disable modules as needed
- **Type-safe variables**: All variables have proper types and validation
- **Comprehensive testing**: Terraform tests for all major modules
- **Clear outputs**: Only expose necessary information

## Available Modules

### Active Modules

- **dns_networking**: DNS zone and record management
- **email_management**: Email routing and forwarding rules
- **zero_trust_security**: Zero Trust tunnels, access policies, and gateway rules

### Additional Modules (Scaffolded)

- **account_authentication**: Account settings and API tokens
- **security_bot_management**: Bot management and firewall rules
- **ssl_tls_certificates**: SSL/TLS certificate management
- **workers**: Cloudflare Workers and KV storage
- **pages_delivery**: Cloudflare Pages projects
- **r2_storage**: R2 bucket management

## Quick Start

### Prerequisites

- Terraform >= 1.0.0
- Cloudflare account with API token
- Zone IDs for any zones you want to manage

### Basic Usage

```hcl
module "cloudflare" {
  source = "path/to/module"

  cloudflare_api_token = var.cloudflare_api_token
  account_id           = var.account_id
  environment          = "production"

  # Define zones to manage
  zones = {
    "example.com" = {
      id   = "your-zone-id-here"
      name = "example.com"
    }
  }

  # Enable specific modules
  enabled_modules = {
    dns_networking      = true
    email_management    = true
    zero_trust_security = true
    # ... others disabled by default
  }

  # DNS configuration
  dns_networking_config = {
    records = [
      {
        zone_key = "example.com"
        records = [
          {
            name    = "www"
            type    = "A"
            content = "192.0.2.1"
            ttl     = 3600
            proxied = true
          }
        ]
      }
    ]
  }
}
```

## Module Configuration

### DNS Networking

Manages DNS records across multiple zones:

```hcl
dns_networking_config = {
  records = [
    {
      zone_key = "example.com"
      records = [
        {
          name    = "www"
          type    = "A"
          content = "192.0.2.1"
          ttl     = 3600
          proxied = true
          comment = "Web server"
        }
      ]
    }
  ]
}
```

See [modules/dns_networking/README.md](modules/dns_networking/README.md) for details.

### Email Management

Configures email routing rules:

```hcl
email_management_config = {
  aliasroute2email = [
    {
      alias          = "info"
      action         = "forward"
      email_to_route = "admin@example.com"
      zone_key       = "example.com"
    }
  ]
  catch_all_rule = {
    zone_key       = "example.com"
    catchall_email = "catchall@example.com"
  }
}
```

See [modules/email_management/README.md](modules/email_management/README.md) for details.

### Zero Trust Security

Manages tunnels, access policies, and gateway rules:

```hcl
zero_trust_config = {
  tunnels = {
    "my-tunnel" = {
      name       = "my-tunnel"
      config_src = "cloudflare"
      routes     = []
    }
  }
  access_policies = {
    "allow-team" = {
      name     = "Allow Team"
      decision = "allow"
      include  = [{ everyone = {} }]
    }
  }
}

cloudflare_secrets = {
  tunnel_secrets = {
    "my-tunnel" = {
      secret = var.tunnel_secret  # Store securely!
    }
  }
}
```

See [modules/zero_trust_security/README.md](modules/zero_trust_security/README.md) for details.

## Testing

Each module includes Terraform tests. Run them locally with:

```bash
# Test all modules
terraform test

# Test specific module
terraform test -test-directory=modules/dns_networking/tests
```

### Continuous Integration

All pull requests automatically run:
- **Format checks**: Ensures code is properly formatted
- **Validation**: Validates all modules and examples
- **Tests**: Runs all module tests in parallel

See [.github/workflows/README.md](.github/workflows/README.md) for details on CI/CD pipelines.

## Development

### Project Structure

```
.
├── main.tf                    # Root module configuration
├── variables.tf               # Root input variables
├── outputs.tf                 # Root outputs
├── provider.tf                # Provider configuration
├── modules/
│   ├── dns_networking/        # DNS module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   ├── README.md
│   │   └── tests/
│   ├── email_management/      # Email module
│   │   └── ...
│   └── zero_trust_security/   # Zero Trust module
│       └── ...
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes following the patterns established
4. Add/update tests
5. Update documentation
6. Submit a pull request

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| cloudflare | ~> 5.8 |

## Inputs

See [variables.tf](variables.tf) for a complete list of input variables.

Key variables:
- `cloudflare_api_token` (required, sensitive): API token for Cloudflare
- `account_id` (required): Cloudflare account ID
- `zones` (required): Map of zones to manage
- `environment` (optional): Environment tag (default: "production")
- `enabled_modules` (optional): Map of modules to enable/disable

## Outputs

See [outputs.tf](outputs.tf) for available outputs from each module.

## License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

For issues and questions:
- Check module-specific READMEs
- Review the [CHANGELOG](CHANGELOG.md)
- Open a GitHub issue

