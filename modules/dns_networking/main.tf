
resource "cloudflare_bot_management" "this" {
  zone_id = var.zone.id
  fight_mode = var.cloudflare_bot_management.fight_mode
  enable_js  = var.cloudflare_bot_management.enable_js

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
  value    = each.value.value
  ttl      = each.value.proxied ? 1 : each.value.ttl
  proxied  = each.value.proxied
  comment  = each.value.comment
  priority = each.value.type == "MX" ? each.value.priority : null

  lifecycle {
    create_before_destroy = true
  }
}

