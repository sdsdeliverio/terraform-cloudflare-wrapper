terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

locals {
  email_routing_addresses = {
    for config in var.aliasroute2email :
    "${var.environment}/${config.alias}-[${base64sha256("${config.alias}_${config.email_to_route}")}]" => {
      email  = config.email_to_route
      action = config.action
      alias  = config.alias
    }
  }

  routing_emails = {
    for key, config in local.email_routing_addresses : "${var.environment}/${config.email}-route[${base64sha256(config.email)}]" => config
    if config.email != null
  }

  forwarding_rules = {
    for key, config in local.email_routing_addresses : "${var.environment}/${config.alias}-2-${config.email}-[${base64sha256("${config.alias}-2-${config.email}")}]" => config
    if length(trimspace(config.alias)) > 0 && config.action == "forward"
  }

  drop_rules = {
    for key, config in local.email_routing_addresses : "${var.environment}/${config.alias}-drop[${base64sha256(config.alias)}]" => config
    if config.action == "drop"
  }

  # Mapping zones for lookup
  zones_map = { for zone in var.zones : zone.id => zone }
}


resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = local.zones_map[var.default_zone_id].id
  actions = [{
    type  = try(var.catch_all_rule.catchall_email, null) == null ? "drop" : "forward"
    value = try([var.catch_all_rule.catchall_email], [])
  }]
  matchers = [{
    type = "all"
  }]
  enabled = true
  name    = "Catch all ${try(var.catch_all_rule.catchall_email, null) == null ? "" : var.catch_all_rule.catchall_email} ${try(var.catch_all_rule.catchall_email, null) == null ? "drop" : "forward"} Email rule."

  lifecycle {
    prevent_destroy = true
  }
}

# We need to change this to iterate over the zones depending on the emails we manage for each zone
# resource "cloudflare_email_routing_settings" "this" {
#   zone_id = local.zones_map[var.default_zone_id].id
# }

# resource "cloudflare_email_routing_dns" "this" {
#   zone_id = local.zones_map[var.default_zone_id].id
#   name = local.zones_map[var.default_zone_id].name
# }

resource "cloudflare_email_routing_address" "this" {
  for_each = local.routing_emails

  account_id = var.account_id
  email      = each.value.email
}

resource "cloudflare_email_routing_rule" "forwarding" {
  for_each = local.forwarding_rules

  zone_id = local.zones_map[var.default_zone_id].id
  actions = [{
    type  = "forward"
    value = ["${each.value.email}"]
  }]
  matchers = [{
    type  = "literal"
    field = "to"
    value = "${each.value.alias}@${local.zones_map[var.default_zone_id].name}"
  }]
  enabled  = true
  name     = "Forward alias ${each.value.alias} to ${each.value.email} rule. Managed by Terraform"
  priority = 0
}

resource "cloudflare_email_routing_rule" "drop" {
  for_each = local.drop_rules

  zone_id = local.zones_map[var.default_zone_id].id
  actions = [{
    type = "drop"
  }]
  matchers = [{
    type  = "literal"
    field = "to"
    value = "${each.value.alias}@${local.zones_map[var.default_zone_id].name}"
  }]
  enabled  = true
  name     = "Drop all emails to ${each.value.alias} rule. Managed by Terraform"
  priority = 0
}

# resource "cloudflare_email_security_block_sender" "example_email_security_block_sender" {
#   account_id   = "023e105f4ecef8ad9ca31a8372d0c353"
#   is_regex     = true
#   pattern      = "x"
#   pattern_type = "EMAIL"
#   comments     = "comments"
# }

# resource "cloudflare_email_security_impersonation_registry" "example_email_security_impersonation_registry" {
#   account_id     = "023e105f4ecef8ad9ca31a8372d0c353"
#   email          = "email"
#   is_email_regex = true
#   name           = "name"
# }
# resource "cloudflare_email_security_trusted_domains" "example_email_security_trusted_domains" {
#   account_id    = "023e105f4ecef8ad9ca31a8372d0c353"
#   is_recent     = true
#   is_regex      = true
#   is_similarity = true
#   pattern       = "x"
#   comments      = "comments"
# }
