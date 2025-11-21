output "zones" {
  description = "Map of created DNS zones"
  value       = var.zones
}

output "dns_records" {
  description = "Map of created DNS records"
  value = { for k, v in cloudflare_dns_record.this : k => {
    id      = v.id
    name    = v.name
    type    = v.type
    content = v.content
    proxied = v.proxied
  } }
}

output "zone_ids" {
  description = "Map of zone ids"
  value       = { for k, v in var.zones : k => v.id }
}

