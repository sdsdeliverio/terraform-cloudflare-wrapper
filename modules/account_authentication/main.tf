terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.5.0"
    }
  }
}

# Account configuration
resource "cloudflare_account" "account" {
  name              = var.account_name
  type              = var.account_type
  enforce_twofactor = var.enforce_twofactor
}

# Account DNS settings
resource "cloudflare_account_dns_settings" "settings" {
  account_id = cloudflare_account.account.id
  enabled    = var.dns_settings_enabled
}

# Internal DNS view settings
resource "cloudflare_account_dns_settings_internal_view" "internal" {
  account_id = cloudflare_account.account.id
  enabled    = var.internal_dns_enabled
}

# Account member management
resource "cloudflare_account_member" "members" {
  for_each = { for member in var.account_members : member.email => member }

  account_id = cloudflare_account.account.id
  email      = each.key
  role_ids   = each.value.role_ids
  status     = "pending"
}

# Account subscription
resource "cloudflare_account_subscription" "subscription" {
  account_id     = cloudflare_account.account.id
  zone_rate_plan = var.subscription_rate_plan
}

# API token configuration
resource "cloudflare_api_token" "token" {
  for_each = { for token in var.api_tokens : token.name => token }

  name = each.key

  policy {
    permission_groups = each.value.permissions
    resources         = each.value.resources
  }
}

# API Shield configuration
resource "cloudflare_api_shield" "shield" {
  for_each = { for zone in var.api_shield_zones : zone.zone_id => zone }

  zone_id = each.key
  enabled = each.value.enabled
}

# API Shield schema
resource "cloudflare_api_shield_schema" "schemas" {
  for_each = { for schema in var.api_shield_schemas : schema.name => schema }

  zone_id    = each.value.zone_id
  name       = each.key
  kind       = each.value.kind
  validation = each.value.validation
}

# API Shield operation configuration
resource "cloudflare_api_shield_operation" "operations" {
  for_each = { for op in var.api_shield_operations : "${op.zone_id}-${op.endpoint}" => op }

  zone_id  = each.value.zone_id
  endpoint = each.value.endpoint
  method   = each.value.method
  host     = each.value.host

  depends_on = [cloudflare_api_shield.shield]
}

