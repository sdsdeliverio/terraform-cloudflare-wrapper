terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

resource "cloudflare_bot_management" "this" {
  ai_bots_protection = "block"
  crawler_protection = "enabled"
  enable_js         = var.cloudflare_bot_management.enable_js
  fight_mode        = var.cloudflare_bot_management.fight_mode
  zone_id          = var.zone.id

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "this" {
  for_each = {
    for idx, record in var.records : "${record.name}-${record.type}-${idx}" => record
  }

  name = (
    each.value.name == "" || each.value.name == "@"
    ? "${var.zone.name}"
    : "${each.value.name}.${var.zone.name}"
  )
    
  zone_id  = var.zone.id
  type     = each.value.type
  content  = each.value.value
  ttl      = each.value.proxied ? 1 : each.value.ttl
  proxied  = each.value.proxied
  comment  = each.value.comment
  priority = each.value.type == "MX" ? each.value.priority : null

  lifecycle {
    create_before_destroy = true
  }
}

