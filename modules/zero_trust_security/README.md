# Zero Trust Security Module

This module manages Cloudflare Zero Trust (formerly Cloudflare Access) resources including tunnels, access policies, applications, and gateway policies.

## Features

- Zero Trust tunnels (cloudflared)
- Virtual networks for private network routing
- Access applications and policies
- Gateway policies for network filtering
- Lists for IP/hostname management
- Zone-level firewall rulesets
- Auto-creation of DNS records for tunnel ingress

## Usage

### Basic Tunnel Configuration

```hcl
module "zero_trust" {
  source = "./modules/zero_trust_security"

  environment = "production"
  account_id  = "your-account-id"
  zones = {
    "example.com" = {
      id   = "zone-id-1"
      name = "example.com"
    }
  }

  cloudflare_secrets = {
    tunnel_secrets = {
      "my-tunnel" = {
        secret = "your-tunnel-secret"
      }
    }
  }

  tunnels = {
    "my-tunnel" = {
      name       = "my-tunnel"
      config_src = "cloudflare"
      routes = []
    }
  }

  virtual_networks = {
    "my-vnet" = {
      is_default_network = true
      comment            = "Default virtual network"
    }
  }
}
```

### Access Application and Policy

```hcl
module "zero_trust" {
  source = "./modules/zero_trust_security"

  # ... other configuration ...

  access_applications = {
    "internal-app" = {
      name             = "Internal Application"
      domain           = "app.example.com"
      type             = "self_hosted"
      session_duration = "24h"
      policies         = ["allow-team"]
    }
  }

  access_policies = {
    "allow-team" = {
      name     = "Allow Team Members"
      decision = "allow"
      include = [
        {
          email_domain = {
            domain = "example.com"
          }
        }
      ]
    }
  }
}
```

### Gateway Policy

```hcl
module "zero_trust" {
  source = "./modules/zero_trust_security"

  # ... other configuration ...

  gateway_policies = {
    "block-malware" = {
      name    = "Block Malware"
      enabled = true
      action  = "block"
      filters = ["http"]
    }
  }
}
```

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| environment | Environment name | string | yes | - |
| account_id | Cloudflare account ID | string | yes | - |
| zones | Map of DNS zones | map(object) | yes | - |
| cloudflare_secrets | Sensitive secrets map | object | no | {} |
| tunnels | Zero Trust tunnel configurations | map(object) | no | {} |
| virtual_networks | Virtual network configurations | map(object) | no | {} |
| access_applications | Access application configurations | map(object) | no | {} |
| access_policies | Access policy configurations | map(object) | no | {} |
| gateway_policies | Gateway policy configurations | map(object) | no | {} |
| lists | Zero Trust list configurations | map(object) | no | {} |
| firewall_ruleset | Firewall ruleset configurations | map(object) | no | {} |

## Outputs

| Name | Description |
|------|-------------|
| tunnels | Map of created tunnels |
| virtual_networks | Map of created virtual networks |
| access_applications_aud_tags | Map of application audience tags |
| access_policies | Map of created access policies |
| gateway_policies | Map of created gateway policies |
| lists | Map of created lists |

## Notes

- Tunnel secrets should be stored securely and passed via `cloudflare_secrets` variable
- Access applications must reference policies by their keys in the `policies` list
- DNS records can be auto-created for tunnel ingress by setting `auto_create_dns_zone_key`
- Virtual networks are required for tunnel routes
- Access policies support complex include/exclude/require logic
- Lists support IP addresses, hostnames, and other types

## Testing

Run the module tests with:

```bash
terraform test -test-directory=modules/zero_trust_security/tests
```
