terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

# resource "cloudflare_bot_management" "this" {
#   zone_id = var.zone.id
#   fight_mode = var.cloudflare_bot_management.fight_mode
#   enable_js  = var.cloudflare_bot_management.enable_js

#   lifecycle {
#     prevent_destroy = true
#   }
# }


resource "cloudflare_dns_record" "this" {
  for_each = { for record in flatten([
    for zone in var.zones : [
      for idx, record in zone.records : {
        key     = "${zone.zone_name}-${record.name}-${record.type}-${idx}"
        zone_id = zone.zone_id
        name    = record.name
        type    = record.type
        value   = record.value
        ttl     = record.ttl
        proxied = try(record.proxied, false)
        comment = try(record.comment, null)
        priority = try(record.priority, null)
        zone_name = zone.zone_name
      }
    ]
  ]) : record.key => record }

  name = (
    each.value.name == "" || each.value.name == "@" 
    ? each.value.zone_name 
    : "${each.value.name}.${each.value.zone_name}"
  )
    
  zone_id  = each.value.zone_id
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
