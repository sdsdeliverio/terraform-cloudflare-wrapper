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

output "routing_addresses" {
  description = "Map of email routing addresses"
  value = { for k, v in cloudflare_email_routing_address.this : k => {
    id    = v.id
    email = v.email
  } }
}

output "routing_rules" {
  description = "Map of email routing rules"
  value = merge(
    { for k, v in cloudflare_email_routing_rule.forwarding : k => {
      id      = v.id
      name    = v.name
      enabled = v.enabled
    } },
    { for k, v in cloudflare_email_routing_rule.drop : k => {
      id      = v.id
      name    = v.name
      enabled = v.enabled
    } }
  )
}

