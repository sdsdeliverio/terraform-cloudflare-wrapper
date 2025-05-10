terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

# Access Application
resource "cloudflare_access_application" "app" {
  for_each = { for app in var.access_applications : app.name => app }

  zone_id          = try(each.value.zone_id, null)
  account_id       = var.account_id
  name             = each.key
  domain           = each.value.domain
  type             = try(each.value.type, "self_hosted")
  session_duration = try(each.value.session_duration, "24h")
}

# Access Policy
resource "cloudflare_access_policy" "policy" {
  for_each = { for policy in var.access_policies : "${policy.application_id}-${policy.name}" => policy }

  # application_id = each.value.application_id
  zone_id    = try(each.value.zone_id, null)
  account_id = var.account_id
  name       = each.value.name
  precedence = each.value.precedence
  decision   = each.value.decision
  include    = each.value.include

  exclude                        = each.value.exclude
  require                        = each.value.require
  session_duration               = each.value.session_duration
  approval_required              = each.value.approval_required
  approval_groups                = each.value.approval_groups
  purpose_justification_prompt   = each.value.purpose_justification_prompt
  purpose_justification_required = each.value.purpose_justification_required
  isolation_required             = each.value.isolation_required

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes = [
      reusable
    ]
  }
  dynamic "include" {
    for_each = [each.value.include]
    content {
      email = try(include.value.email, null)
      group = try(include.value.group, null)
    }
  }
}

# Access Group
# resource "cloudflare_access_group" "group" {
#   for_each = { for group in var.access_groups : group.name => group }

#   account_id = var.account_id
#   name       = each.key

#   dynamic "include" {
#     for_each = [each.value.include]
#     content {
#       email  = try(include.value.email, [])
#       emails = try(include.value.emails, [])
#       group  = try(include.value.group, [])
#     }
#   }
# }

# Zero Trust Gateway Policy
resource "cloudflare_zero_trust_gateway_policy" "policy" {
  for_each = { for policy in var.gateway_policies : policy.name => policy }

  account_id = var.account_id
  name       = each.key
  enabled    = try(each.value.enabled, true)

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name           = rule.value.name
      action         = rule.value.action
      enabled        = try(rule.value.enabled, true)
      filters        = rule.value.filters
      traffic        = rule.value.traffic
      identity       = try(rule.value.identity, [])
      device_posture = try(rule.value.device_posture, [])
    }
  }
}

# # Zero Trust Gateway Settings
# resource "cloudflare_zero_trust_gateway_settings" "settings" {
#   for_each = { for setting in var.gateway_settings : setting.account_id => setting }

#   account_id = each.key
#   antivirus {
#     enabled_download_phase = try(each.value.antivirus_enabled_download, true)
#     enabled_upload_phase   = try(each.value.antivirus_enabled_upload, true)
#     fail_closed            = try(each.value.antivirus_fail_closed, true)
#   }
#   tls_decrypt {
#     enabled = try(each.value.tls_decrypt_enabled, true)
#   }
# }

# Zero Trust Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  for_each = { for tunnel in var.tunnels : tunnel.name => tunnel }

  account_id = var.account_id
  name       = each.key
  secret     = each.value.secret
}

# Zero Trust Virtual Network
resource "cloudflare_zero_trust_tunnel_cloudflared_virtual_network" "vnet" {
  for_each = { for vnet in var.virtual_networks : vnet.name => vnet }

  account_id         = var.account_id
  name               = each.key
  is_default_network = try(each.value.is_default_network, false)
  comment            = try(each.value.comment, null)
}

