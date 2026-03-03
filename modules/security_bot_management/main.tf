# Note: Resources in this module are commented out due to API changes in provider v5.8+
# Uncomment and update when needed for production use.

# # Bot Management
# resource "cloudflare_bot_management" "bot" {
#   for_each = { for zone in var.bot_management_zones : zone.zone_id => zone }
#
#   zone_id           = each.key
#   enable_js         = try(each.value.enable_js, true)
#   fight_mode        = try(each.value.fight_mode, false)
#   # optimization_type removed in v5.8+
# }

# # Firewall Rules - API changed in v5.8+
# resource "cloudflare_firewall_rule" "rules" {
#   for_each = { for rule in var.firewall_rules : "${rule.zone_id}-${rule.description}" => rule }
#
#   zone_id     = each.value.zone_id
#   description = each.value.description
#   # filter_id changed to filter in v5.8+
#   action      = each.value.action
#   priority    = try(each.value.priority, null)
#   paused      = try(each.value.paused, false)
# }

# # User Agent Blocking Rules - API changed in v5.8+
# resource "cloudflare_user_agent_blocking_rule" "ua_rules" {
#   for_each = { for rule in var.ua_blocking_rules : "${rule.zone_id}-${rule.description}" => rule }
#
#   zone_id     = each.value.zone_id
#   description = each.value.description
#   mode        = each.value.mode
#   paused      = try(each.value.paused, false)
#   # configuration structure changed in v5.8+
# }

# # Page Shield Policy - API changed significantly in v5.8+
# resource "cloudflare_page_shield_policy" "policies" {
#   for_each = { for policy in var.page_shield_policies : "${policy.zone_id}-${policy.name}" => policy }
#
#   zone_id = each.value.zone_id
#   # API structure changed in v5.8+
#   action  = each.value.action
#   enabled = try(each.value.enabled, true)
# }

# # Authenticated Origin Pulls - API changed in v5.8+
# resource "cloudflare_authenticated_origin_pulls" "aop" {
#   for_each = { for zone in var.authenticated_origin_pulls : zone.zone_id => zone }
#
#   zone_id = each.key
#   # config structure required in v5.8+
# }

# # Authenticated Origin Pulls Certificate - API changed in v5.8+
# resource "cloudflare_authenticated_origin_pulls_certificate" "cert" {
#   for_each = { for cert in var.origin_pull_certificates : "${cert.zone_id}-${cert.certificate}" => cert }
#
#   zone_id     = each.value.zone_id
#   certificate = each.value.certificate
#   private_key = each.value.private_key
#   # type argument removed in v5.8+
# }

