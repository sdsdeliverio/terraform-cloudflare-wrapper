# DNS Networking outputs
output "dns_networking" {
  description = "DNS networking module outputs"
  value = var.enabled_modules["dns_networking"] ? {
    zones    = module.dns_networking[0].zones
    records  = module.dns_networking[0].dns_records
    zone_ids = module.dns_networking[0].zone_ids
  } : null
}

# Email Management outputs
output "email_management" {
  description = "Email management module outputs"
  value = var.enabled_modules["email_management"] ? {
    routing_addresses = module.email_management[0].routing_addresses
    routing_rules     = module.email_management[0].routing_rules
  } : null
}

# Zero Trust Security outputs
output "zero_trust_security" {
  description = "Zero Trust security module outputs"
  value = var.enabled_modules["zero_trust_security"] ? {
    access_applications = {
      aud_tags = module.zero_trust_security[0].access_applications_aud_tags
    }
    tunnels          = module.zero_trust_security[0].tunnels
    virtual_networks = module.zero_trust_security[0].virtual_networks
  } : null
  sensitive = true
}
