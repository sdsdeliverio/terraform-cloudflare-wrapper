terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

# DNS Zone configuration
resource "cloudflare_zone" "zones" {
  for_each = { for zone in var.zones : zone.name => zone }

  account_id = var.account_id
  zone       = each.key
  paused     = try(each.value.paused, false)
  plan       = try(each.value.plan, "free")
  type       = try(each.value.type, "full")
}

# DNS Records
resource "cloudflare_record" "records" {
  for_each = { for record in var.dns_records : "${record.name}-${record.type}-${record.content}" => record }

  zone_id  = cloudflare_zone.zones[each.value.zone_name].id
  name     = each.value.name
  type     = each.value.type
  content  = each.value.content
  ttl      = try(each.value.ttl, 1)
  proxied  = try(each.value.proxied, true)
  priority = try(each.value.priority, null)
}

# Zone DNS Settings
resource "cloudflare_zone_dns_settings" "settings" {
  for_each = { for zone in var.zones : zone.name => zone }

  zone_id = cloudflare_zone.zones[each.key].id
  enabled = try(each.value.dns_settings_enabled, true)
}

# Zone DNSSEC
resource "cloudflare_zone_dnssec" "dnssec" {
  for_each = { for zone in var.zones : zone.name => zone if try(zone.enable_dnssec, false) }

  zone_id = cloudflare_zone.zones[each.key].id
}

# DNS Firewall
resource "cloudflare_dns_firewall" "firewall" {
  for_each = { for rule in var.dns_firewall_rules : "${rule.name}-${rule.zone_name}" => rule }

  zone_id = cloudflare_zone.zones[each.value.zone_name].id
  name    = each.value.name
  rules   = each.value.rules
}

# Zone Transfers ACL
resource "cloudflare_zone_transfers_acl" "acl" {
  for_each = { for acl in var.zone_transfers_acls : "${acl.zone_name}-${acl.name}" => acl }

  zone_id     = cloudflare_zone.zones[each.value.zone_name].id
  name        = each.value.name
  source_ips  = each.value.source_ips
}

# DNS Address Map
resource "cloudflare_address_map" "address_maps" {
  for_each = { for map in var.address_maps : "${map.account_id}-${map.prefix}" => map }

  account_id = each.value.account_id
  prefix     = each.value.prefix
  enabled    = try(each.value.enabled, true)
  dynamic "ips" {
    for_each = each.value.ips
    content {
      ip = ips.value
    }
  }
}

