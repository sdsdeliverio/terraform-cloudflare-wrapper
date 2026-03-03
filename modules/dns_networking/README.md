# DNS Networking Module

This module manages DNS zones and records in Cloudflare.

## Features

- DNS record management with support for all record types
- Automatic handling of proxied records (TTL set to 1)
- Support for MX record priorities
- Flexible zone configuration
- Support for multiple zones and records

## Usage

```hcl
module "dns_networking" {
  source = "./modules/dns_networking"

  environment = "production"
  account_id  = "your-account-id"

  zones = {
    "example.com" = {
      id   = "zone-id-1"
      name = "example.com"
    }
  }

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
        },
        {
          name     = "mail"
          type     = "MX"
          content  = "mail.example.com"
          ttl      = 3600
          proxied  = false
          priority = 10
          comment  = "Mail server"
        }
      ]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| environment | Environment name for resource tagging | string | no | "production" |
| account_id | The account ID to manage resources for | string | yes | - |
| zones | Map of DNS zones to manage | map(object) | yes | - |
| records | List of zones and their DNS records configurations | list(object) | no | [] |
| dns_firewall_rules | List of DNS firewall rules | list(object) | no | [] |

## Outputs

| Name | Description |
|------|-------------|
| zones | Map of created DNS zones |
| dns_records | Map of created DNS records with details |
| zone_ids | Map of zone IDs keyed by zone name |

## Notes

- When `proxied` is set to `true`, the TTL is automatically set to 1 (Cloudflare requirement)
- For MX records, set `proxied` to `false` and provide a `priority` value
- Record names can be empty or "@" to represent the root domain
- All records are tagged with environment and managed by Terraform

## Testing

Run the module tests with:

```bash
terraform test -test-directory=modules/dns_networking/tests
```
