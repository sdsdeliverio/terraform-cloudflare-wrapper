

# Bot Management
resource "cloudflare_bot_management" "bot" {
  for_each = { for zone in var.bot_management_zones : zone.zone_id => zone }

  zone_id           = each.key
  enable_js        = try(each.value.enable_js, true)
  fight_mode       = try(each.value.fight_mode, false)
  optimization_type = try(each.value.optimization_type, "balanced")
}

# Firewall Rules
resource "cloudflare_firewall_rule" "rules" {
  for_each = { for rule in var.firewall_rules : "${rule.zone_id}-${rule.description}" => rule }

  zone_id     = each.value.zone_id
  description = each.value.description
  filter_id   = each.value.filter_id
  action      = each.value.action
  priority    = try(each.value.priority, null)
  paused      = try(each.value.paused, false)
}

# User Agent Blocking Rules
resource "cloudflare_user_agent_blocking_rule" "ua_rules" {
  for_each = { for rule in var.ua_blocking_rules : "${rule.zone_id}-${rule.description}" => rule }

  zone_id     = each.value.zone_id
  description = each.value.description
  mode        = each.value.mode
  paused      = try(each.value.paused, false)
  configuration {
    target = each.value.target
    value  = each.value.value
  }
}

# Page Shield Policy
resource "cloudflare_page_shield_policy" "policies" {
  for_each = { for policy in var.page_shield_policies : "${policy.zone_id}-${policy.name}" => policy }

  zone_id = each.value.zone_id
  name    = each.value.name
  action  = each.value.action
  enabled = try(each.value.enabled, true)
}

# Authenticated Origin Pulls
resource "cloudflare_authenticated_origin_pulls" "aop" {
  for_each = { for zone in var.authenticated_origin_pulls : zone.zone_id => zone }

  zone_id = each.key
  enabled = each.value.enabled
}

# Authenticated Origin Pulls Certificate
resource "cloudflare_authenticated_origin_pulls_certificate" "cert" {
  for_each = { for cert in var.origin_pull_certificates : "${cert.zone_id}-${cert.certificate}" => cert }

  zone_id      = each.value.zone_id
  certificate  = each.value.certificate
  private_key = each.value.private_key
  type        = try(each.value.type, "per-zone")
}

