terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.5.0"
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

  account_id    = var.account_id
  name          = each.value.name
  config_src    = each.value.config_src
  tunnel_secret = try(var.cloudflare_secrets.tunnel_secrets[each.key].secret, null)
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "this" {
  for_each = {
    for route in flatten([
      for tunnel_key, tunnel in var.tunnels : [
        for route_idx, route in tunnel.routes : {
          key        = "${tunnel_key}-${route_idx}"
          tunnel_key = tunnel_key
          route      = route
        }
      ]
      ]) : route.key => {
      tunnel_key = route.tunnel_key
      route      = route.route
    }
  }

  tunnel_id          = cloudflare_zero_trust_tunnel_cloudflared.this[each.value.tunnel_key].id
  account_id         = var.account_id
  network            = each.value.route.network
  comment            = each.value.route.comment
  virtual_network_id = cloudflare_zero_trust_tunnel_cloudflared_virtual_network.this[each.value.route.virtual_network].id

  depends_on = [
    cloudflare_zero_trust_tunnel_cloudflared.this,
    cloudflare_zero_trust_tunnel_cloudflared_virtual_network.this
  ]
}

# Zero Trust Virtual Network
resource "cloudflare_zero_trust_tunnel_cloudflared_virtual_network" "this" {
  for_each = var.virtual_networks

  account_id         = var.account_id
  name               = each.key
  is_default         = try(each.value.is_default, false)
  is_default_network = try(each.value.is_default_network, false)
  comment            = try(each.value.comment, null)
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "with_cloudflared_config" {
  for_each = {
    for tunnel_key, tunnel in var.tunnels : tunnel_key => tunnel
    if contains(keys(tunnel), "cloudflared_config")
  }

  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this[each.key].id

  source = each.value.config_src

  config = {
    ingress = [
      for ingress in each.value.cloudflared_config.ingress : {
        hostname = ingress.hostname
        service  = ingress.service
        path     = ingress.path
        origin_request = ingress.origin_request != null ? {
          access = ingress.origin_request.access != null ? {
            aud_tag = coalesce(
              [
                for app_key in ingress.origin_request.access.aud_tag :
                cloudflare_zero_trust_access_application.this[app_key].aud
              ],
              null
            )
            team_name = ingress.origin_request.access.team_name
            required  = ingress.origin_request.access.required
          } : null
          ca_pool                  = ingress.origin_request.ca_pool
          connect_timeout          = ingress.origin_request.connect_timeout
          disable_chunked_encoding = ingress.origin_request.disable_chunked_encoding
          http2_origin             = ingress.origin_request.http2_origin
          http_host_header         = ingress.origin_request.http_host_header
          keep_alive_connections   = ingress.origin_request.keep_alive_connections
          keep_alive_timeout       = ingress.origin_request.keep_alive_timeout
          no_happy_eyeballs        = ingress.origin_request.no_happy_eyeballs
          no_tls_verify            = ingress.origin_request.no_tls_verify
          origin_server_name       = ingress.origin_request.origin_server_name
          proxy_type               = ingress.origin_request.proxy_type
          tcp_keep_alive           = ingress.origin_request.tcp_keep_alive
          tls_timeout              = ingress.origin_request.tls_timeout
        } : null
      }
    ]
    origin_request = each.value.cloudflared_config.origin_request != null ? {
      access = each.value.cloudflared_config.origin_request.access != null ? {
        aud_tag = coalesce(
          [
            for app_key in try(each.value.each.value.cloudflared_config.origin_request.access.aud_tag, []) :
            cloudflare_zero_trust_access_application.this[app_key].aud
          ],
          null
        )
        team_name = each.value.cloudflared_config.origin_request.access.team_name
        required  = each.value.cloudflared_config.origin_request.access.required
      } : null
      ca_pool                  = each.value.cloudflared_config.origin_request.ca_pool
      connect_timeout          = each.value.cloudflared_config.connect_timeout
      disable_chunked_encoding = each.value.cloudflared_config.disable_chunked_encoding
      http2_origin             = each.value.cloudflared_config.http2_origin
      http_host_header         = each.value.cloudflared_config.http_host_header
      keep_alive_connections   = each.value.cloudflared_config.keep_alive_connections
      keep_alive_timeout       = each.value.cloudflared_config.keep_alive_timeout
      no_happy_eyeballs        = each.value.cloudflared_config.no_happy_eyeballs
      no_tls_verify            = each.value.cloudflared_config.no_tls_verify
      origin_server_name       = each.value.cloudflared_config.origin_server_name
      proxy_type               = each.value.cloudflared_config.proxy_type
      tcp_keep_alive           = each.value.cloudflared_config.tcp_keep_alive
      tls_timeout              = each.value.cloudflared_config.tls_timeout
    } : null
    warp_routing = try(each.value.cloudflared_config.warp_routing, { enabled = true })
  }

  depends_on = [
    cloudflare_zero_trust_tunnel_cloudflared.this,
    cloudflare_zero_trust_access_application.this
  ]

  # lifecycle {
  #   prevent_destroy = false
  # }
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "without_cloudflared_config" {
  for_each = {
    for tunnel_key, tunnel in var.tunnels : tunnel_key => tunnel
    if !contains(keys(tunnel), "cloudflared_config") && cloudflare_zero_trust_tunnel_cloudflared_config.with_cloudflared_config[tunnel_key] == null
  }

  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this[each.key].id

  source = each.value.config_src

  depends_on = [
    cloudflare_zero_trust_tunnel_cloudflared.this,
  ]

  # lifecycle {
  #   prevent_destroy = false
  # }
}

# variable "tunnels" {
#   description = "List of Zero Trust tunnels"
#   type = map(object({
#     name       = string
#     config_src = optional(string, "cloudflare")
#     routes = optional(list(object({
#       virtual_network = string
#       network         = string
#       comment         = string
#     })), [])
#     cloudflared_config = optional(object({
#       ingress = list(object({
#         hostname        = optional(string)
#         auto_create_dns_zone_key = optional(string, null)
# Create DNS records for hostnames in tunnel configs where auto_create_dns is different from null otherwise use it as key for lookup in var.zones.name and the  get the id
#   var.tunnels[*].cloudflared_config.ingress[*].auto_create_dns_zone_key use this key to create the dns records for each ingress.hostname
resource "cloudflare_dns_record" "tunnel_dns_records" {
  for_each = {
    for pair in flatten([
      for tunnel_key, tunnel in var.tunnels : [
        for ingress in tunnel.cloudflared_config.ingress : {
          tunnel_key = tunnel_key
          hostname   = ingress.hostname
          zone_key   = ingress.auto_create_dns_zone_key
        }
        if ingress.auto_create_dns_zone_key != null && ingress.hostname != null
      ]
      ]) : "${var.environment}/${pair.hostname}_${pair.tunnel_key}-[${base64sha256(pair.hostname)}]" => {

      name    = pair.hostname
      zone_id = var.zones[pair.zone_key].id
      type    = "CNAME"
      content = "${cloudflare_zero_trust_tunnel_cloudflared.this[pair.tunnel_key].id}.cfargotunnel.com"
      ttl     = 1
      proxied = true
      comment = "Auto-created by Terraform for tunnel [${pair.tunnel_key}]"
    }
  }

  zone_id = each.value.zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.content
  ttl     = each.value.ttl
  proxied = each.value.proxied
  comment = each.value.comment

  depends_on = [
    cloudflare_zero_trust_tunnel_cloudflared.this,
    cloudflare_zero_trust_tunnel_cloudflared_config.with_cloudflared_config
  ]
}

# Cloudflare Ruleset
resource "cloudflare_ruleset" "this" {
  for_each = var.firewall_ruleset

  kind        = each.value.kind
  name        = each.value.name
  phase       = each.value.phase
  description = each.value.description
  zone_id     = var.zones[each.value.zone_key].id

  rules = [
    for rule in each.value.rules : {
      action      = rule.action
      description = rule.description
      expression  = rule.expression
      enabled     = rule.enabled
    
    }
  ]
}
