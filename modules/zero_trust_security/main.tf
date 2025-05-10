terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}


# Access Policy
resource "cloudflare_zero_trust_access_policy" "this" {
  for_each = var.access_policies

  name       = each.value.name
  account_id = var.account_id
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
    # prevent_destroy       = false
    # ignore_changes = [
    #   reusable
    # ]
  }
}

# Access Application
resource "cloudflare_zero_trust_access_application" "this" {
  for_each = { for idx, app in var.access_applications : idx => app }

  name                         = each.value.name
  domain                       = each.value.domain
  type                         = each.value.type
  account_id                   = var.account_id
  allow_authenticate_via_warp  = each.value.allow_authenticate_via_warp
  allowed_idps                 = each.value.allowed_idps
  app_launcher_visible         = each.value.app_launcher_visible
  auto_redirect_to_identity    = each.value.auto_redirect_to_identity
  cors_headers                 = each.value.cors_headers
  custom_deny_message          = each.value.custom_deny_message
  custom_deny_url              = each.value.custom_deny_url
  custom_non_identity_deny_url = each.value.custom_non_identity_deny_url
  custom_pages                 = each.value.custom_pages
  destinations                 = each.value.destinations
  enable_binding_cookie        = each.value.enable_binding_cookie
  http_only_cookie_attribute   = each.value.http_only_cookie_attribute
  logo_url                     = each.value.logo_url
  options_preflight_bypass     = each.value.options_preflight_bypass
  path_cookie_attribute        = each.value.path_cookie_attribute
  policies = [
    for policy_key in each.value.policies : {
      id         = cloudflare_zero_trust_access_policy.this[policy_key].id
      precedence = index(each.value.policies, policy_key)
    }
  ]
  read_service_tokens_from_header = each.value.read_service_tokens_from_header
  same_site_cookie_attribute      = each.value.same_site_cookie_attribute
  service_auth_401_redirect       = each.value.service_auth_401_redirect
  session_duration                = each.value.session_duration
  skip_interstitial               = each.value.skip_interstitial
  tags                            = each.value.tags
  skip_app_launcher_login_page    = true

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false

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
# resource "cloudflare_zero_trust_gateway_policy" "policy" {
#   for_each = { for policy in var.gateway_policies : policy.name => policy }

#   account_id = var.account_id
#   name       = each.key
#   enabled    = try(each.value.enabled, true)

#   dynamic "rule" {
#     for_each = each.value.rules
#     content {
#       name           = rule.value.name
#       action         = rule.value.action
#       enabled        = try(rule.value.enabled, true)
#       filters        = rule.value.filters
#       traffic        = rule.value.traffic
#       identity       = try(rule.value.identity, [])
#       device_posture = try(rule.value.device_posture, [])
#     }
#   }
# }

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
resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  for_each = var.tunnels

  account_id = var.account_id
  name       = each.value.name
  config_src = each.value.config_src
  tunnel_secret  = try(var.cloudflare_secrets.tunnel_secrets[each.key].secret, null)
}

# # # Zero Trust Virtual Network
resource "cloudflare_zero_trust_tunnel_cloudflared_virtual_network" "this" {
  for_each = var.virtual_networks

  account_id         = var.account_id
  name               = each.value.name
  is_default_network = try(each.value.is_default_network, false)
  comment            = try(each.value.comment, null)
}