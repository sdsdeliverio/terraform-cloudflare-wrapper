terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

locals {
  # Create a map of zone_key to zone details for easier lookup
  zones_map = { for zone in var.zones : zone.name => zone }
}


resource "cloudflare_dns_record" "this" {
  for_each = { for record in flatten([
    for config in var.records : [
      for idx, record in config.records : {
        key       = "${var.environment}/${record.name}.${config.zone_key}_${record.type}-[${base64sha256(record.content)}]"
        zone_id   = local.zones_map[config.zone_key].id
        name      = record.name
        type      = record.type
        content   = record.content
        ttl       = record.ttl
        proxied   = try(record.proxied, false)
        comment   = try(record.comment, "Managed by Terraform")
        priority  = try(record.priority, null)
        zone_name = config.zone_key
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
  content  = each.value.content
  ttl      = each.value.proxied ? 1 : each.value.ttl
  proxied  = each.value.proxied
  comment  = each.value.comment
  priority = each.value.type == "MX" ? each.value.priority : null

}