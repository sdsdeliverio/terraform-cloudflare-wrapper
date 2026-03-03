# Account configuration
resource "cloudflare_account" "account" {
  name = var.account_name
  type = var.account_type
  # Note: enforce_twofactor is deprecated in provider v5.8+
}

# Note: The resources below are commented out due to significant API changes in
# Cloudflare provider v5.8+. These scaffolded resources require updates to match
# the current provider schema. Uncomment and update when needed.

# # Account DNS settings
# resource "cloudflare_account_dns_settings" "settings" {
#   count      = var.dns_settings_enabled ? 1 : 0
#   account_id = cloudflare_account.account.id
#   # API has changed significantly in v5.8+
# }

# # Internal DNS view settings  
# resource "cloudflare_account_dns_settings_internal_view" "internal" {
#   count      = var.internal_dns_enabled ? 1 : 0
#   account_id = cloudflare_account.account.id
#   name       = var.internal_dns_view_name
#   zones      = [] # Required in v5.8+
# }

# # Account member management
# resource "cloudflare_account_member" "members" {
#   for_each = { for member in var.account_members : member.email => member }
#
#   account_id = cloudflare_account.account.id
#   email      = each.key
#   # role_ids changed to roles in v5.8+
#   status     = "pending"
# }

# # Account subscription
# resource "cloudflare_account_subscription" "subscription" {
#   account_id     = cloudflare_account.account.id
#   # zone_rate_plan API changed in v5.8+
# }

# # API token configuration
# resource "cloudflare_api_token" "token" {
#   for_each = { for token in var.api_tokens : token.name => token }
#
#   name = each.key
#   # policies structure changed significantly in v5.8+
# }

# API Shield configuration
resource "cloudflare_api_shield" "shield" {
  for_each = { for zone in var.api_shield_zones : zone.zone_id => zone }

  zone_id                 = each.key
  auth_id_characteristics = try(each.value.auth_id_characteristics, [])
  # Note: enabled argument removed in provider v5.8+
}

# API Shield schema
resource "cloudflare_api_shield_schema" "schemas" {
  for_each = { for schema in var.api_shield_schemas : schema.name => schema }

  zone_id = each.value.zone_id
  name    = each.key
  kind    = each.value.kind
  file    = each.value.file
  # Note: validation argument replaced with file in provider v5.8+
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

