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

output "catch_all_rule" {
  description = "Catch all email routing rule"
  value = length(cloudflare_email_routing_catch_all.this) > 0 ? {
    id      = cloudflare_email_routing_catch_all.this[0].id
    name    = cloudflare_email_routing_catch_all.this[0].name
    enabled = cloudflare_email_routing_catch_all.this[0].enabled
  } : null
}

