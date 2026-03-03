output "dns_zones" {
  description = "DNS zone information"
  value       = module.cloudflare.dns_networking.zones
}

output "dns_records" {
  description = "Created DNS records"
  value       = module.cloudflare.dns_networking.dns_records
  sensitive   = false
}

output "email_routing_addresses" {
  description = "Email routing addresses"
  value       = module.cloudflare.email_management.routing_addresses
}

output "zero_trust_tunnel_id" {
  description = "Zero Trust tunnel IDs"
  value = {
    for name, tunnel in module.cloudflare.zero_trust_security.tunnels :
    name => tunnel.id
  }
  sensitive = true
}

output "zero_trust_virtual_networks" {
  description = "Virtual network IDs"
  value       = module.cloudflare.zero_trust_security.virtual_networks
}
