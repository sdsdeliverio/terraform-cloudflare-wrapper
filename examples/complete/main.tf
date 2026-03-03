module "cloudflare" {
  source = "../../"

  cloudflare_api_token = var.cloudflare_api_token
  account_id           = var.account_id
  environment          = var.environment
  zones                = var.zones

  # Enable modules
  enabled_modules = {
    dns_networking      = true
    email_management    = true
    zero_trust_security = true
    # Other modules disabled
    account_authentication  = false
    security_bot_management = false
    ssl_tls_certificates    = false
    workers                 = false
    pages_delivery          = false
    r2_storage              = false
  }

  # DNS Configuration
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
            comment = "Web server - managed by Terraform"
          },
          {
            name    = "api"
            type    = "A"
            content = "192.0.2.2"
            ttl     = 3600
            proxied = true
            comment = "API server - managed by Terraform"
          },
          {
            name     = "mail"
            type     = "MX"
            content  = "mail.example.com"
            ttl      = 3600
            proxied  = false
            priority = 10
            comment  = "Mail server - managed by Terraform"
          },
          {
            name    = "blog"
            type    = "CNAME"
            content = "www.example.com"
            ttl     = 3600
            proxied = true
            comment = "Blog redirect - managed by Terraform"
          }
        ]
      }
    ]
  }

  # Email Management Configuration
  email_management_config = {
    aliasroute2email = [
      {
        alias          = "info"
        action         = "forward"
        email_to_route = var.admin_email
        zone_key       = "example.com"
      },
      {
        alias          = "contact"
        action         = "forward"
        email_to_route = var.admin_email
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
      catchall_email = var.catchall_email
    }
  }

  # Zero Trust Configuration
  zero_trust_config = {
    # Virtual Network
    virtual_networks = {
      "production-vnet" = {
        is_default_network = true
        comment            = "Production virtual network"
      }
    }

    # Tunnel
    tunnels = {
      "production-tunnel" = {
        name       = "production-tunnel"
        config_src = "cloudflare"
        routes = [
          {
            virtual_network = "production-vnet"
            network         = "10.0.0.0/24"
            comment         = "Internal network route"
          }
        ]
        cloudflared_config = {
          ingress = [
            {
              hostname                 = "internal.example.com"
              service                  = "http://localhost:8080"
              auto_create_dns_zone_key = "example.com"
            },
            {
              service = "http_status:404"
            }
          ]
        }
      }
    }

    # Access Application
    access_applications = {
      "internal-app" = {
        name             = "Internal Application"
        domain           = "internal.example.com"
        type             = "self_hosted"
        session_duration = "24h"
        policies         = ["allow-team"]
      }
    }

    # Access Policy
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
        session_duration = "24h"
      }
    }

    # IP Allow List
    lists = {
      "office-ips" = {
        name        = "Office IP Addresses"
        type        = "IP"
        description = "Company office IP addresses"
        items = [
          {
            value       = "203.0.113.1"
            description = "Office HQ"
          },
          {
            value       = "203.0.113.2"
            description = "Office Branch"
          }
        ]
      }
    }
  }

  # Tunnel Secrets (sensitive)
  cloudflare_secrets = {
    tunnel_secrets = {
      "production-tunnel" = {
        secret = var.tunnel_secret
      }
    }
  }

  # Tags
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Example"
  }
}
