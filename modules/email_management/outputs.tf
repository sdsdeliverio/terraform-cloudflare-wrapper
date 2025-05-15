# output "zones" {
#   description = "Map of created DNS zones"
#   value       = var.zones
# }

# output "dns_records" {
#   description = "Map of created DNS records"
#   value = { for k, v in cloudflare_dns_record.this : k => {
#     id      = v.id
#     name    = v.name
#     type    = v.type
#     content = v.content
#     proxied = v.proxied
#     }
#   }
# }

# output "zone_ids" {
#   description = "Map of zone ids"
#   value       = { for k, v in var.zones : k => v.id }
# }

# output "dns_settings" {
#   description = "Map of zone DNS settings"
#   value       = { for k, v in cloudflare_zone_dns_settings.settings : k => {
#     id      = v.id
#     enabled = v.enabled
#   }}
# }

# output "firewall_rules" {
#   description = "Map of DNS firewall rules"
#   value       = { for k, v in cloudflare_dns_firewall.firewall : k => {
#     id    = v.id
#     name  = v.name
#     rules = v.rules
#   }}
# }

# output "address_maps" {
#   description = "Map of address maps"
#   value       = { for k, v in cloudflare_address_map.address_maps : k => {
#     id      = v.id
#     prefix  = v.prefix
#     enabled = v.enabled
#   }}
# }

# output "bot_management" {
#   description = "Bot management configuration"
#   value       = {
#     zone_id = cloudflare_bot_management.this.zone_id
#     enabled = cloudflare_bot_management.this.enable_js
#   }
# }
