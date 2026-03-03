# Email Management Module

This module manages Cloudflare Email Routing functionality including forwarding rules, drop rules, and catch-all configurations.

## Features

- Email address verification and routing
- Forwarding rules for email aliases
- Drop rules for unwanted email addresses
- Catch-all rule configuration
- Support for multiple zones

## Usage

```hcl
module "email_management" {
  source = "./modules/email_management"

  environment = "production"
  account_id  = "your-account-id"

  zones = {
    "example.com" = {
      id   = "zone-id-1"
      name = "example.com"
    }
  }

  aliasroute2email = [
    {
      alias          = "info"
      action         = "forward"
      email_to_route = "admin@example.com"
      zone_key       = "example.com"
    },
    {
      alias          = "spam"
      action         = "drop"
      email_to_route = ""
      zone_key       = "example.com"
    }
  ]

  catch_all_rule = {
    zone_key       = "example.com"
    catchall_email = "catchall@example.com"
  }
}
```

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| environment | Environment name for resource tagging | string | no | "production" |
| account_id | The account ID to manage resources for | string | yes | - |
| zones | Map of DNS zones | map(object) | yes | - |
| aliasroute2email | List of email routing configurations | list(object) | no | [] |
| catch_all_rule | Catch-all email routing configuration | object | no | null |

## Outputs

| Name | Description |
|------|-------------|
| routing_addresses | Map of verified email routing addresses |
| routing_rules | Map of all routing rules (forwarding + drop) |
| catch_all_rule | Catch-all rule configuration if enabled |

## Notes

- Email addresses specified in `email_to_route` must be verified in Cloudflare
- Forward action requires a valid `email_to_route` value
- Drop action does not require an `email_to_route` value
- Catch-all rules apply to all unmatched email addresses on the zone
- Set `catchall_email` to `null` to configure a drop catch-all rule

## Testing

Run the module tests with:

```bash
terraform test -test-directory=modules/email_management/tests
```
