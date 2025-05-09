locals {
  common_tags = merge(
    var.tags,
    {
      environment = var.environment
      managed_by  = "terraform"
    }
  )
}

# # Account Authentication Module
# module "account_authentication" {
#   count  = var.enabled_modules["account_authentication"] ? 1 : 0
#   source = "./modules/account_authentication"

#   account_name   = try(var.account_auth_config.name, null)
#   account_type   = try(var.account_auth_config.type, "standard")
#   api_tokens     = try(var.account_auth_config.api_tokens, [])
#   account_members = try(var.account_auth_config.members, [])
}

# DNS Networking Module
module "dns_networking" {
  count  = var.enabled_modules["dns_networking"] ? 1 : 0
  source = "./modules/dns_networking"

  account_id = var.account_id
  zones = [{
    zone_name = var.zone_name
    zone_id   = var.zone_id
    records   = var.dns_records
  }]
}

# # Security Bot Management Module
# module "security_bot_management" {
#   count  = var.enabled_modules["security_bot_management"] ? 1 : 0
#   source = "./modules/security_bot_management"

#   account_id = var.account_id
#   firewall_rules = try(var.security_bot_config.firewall_rules, [])
#   ua_blocking_rules = try(var.security_bot_config.ua_rules, [])
# }

# # SSL/TLS Certificates Module
# module "ssl_tls_certificates" {
#   count  = var.enabled_modules["ssl_tls_certificates"] ? 1 : 0
#   source = "./modules/ssl_tls_certificates"

#   certificate_packs = try(var.ssl_tls_config.certificate_packs, [])
#   custom_ssl_configs = try(var.ssl_tls_config.custom_ssl, [])
# }

# # Workers Module
# module "workers" {
#   count  = var.enabled_modules["workers"] ? 1 : 0
#   source = "./modules/workers"

#   account_id = var.account_id
#   workers_scripts = try(var.workers_config.scripts, [])
#   kv_namespaces = try(var.workers_config.kv_namespaces, [])
# }

# # Zero Trust Security Module
# module "zero_trust_security" {
#   count  = var.enabled_modules["zero_trust_security"] ? 1 : 0
#   source = "./modules/zero_trust_security"

#   account_id = var.account_id
#   access_applications = try(var.zero_trust_config.applications, [])
#   access_policies = try(var.zero_trust_config.policies, [])
#   tunnels = try(var.zero_trust_config.tunnels, [])
# }

# # Pages Delivery Module
# module "pages_delivery" {
#   count  = var.enabled_modules["pages_delivery"] ? 1 : 0
#   source = "./modules/pages_delivery"

#   account_id = var.account_id
#   pages_projects = try(var.pages_delivery_config.projects, [])
#   pages_domains = try(var.pages_delivery_config.domains, [])
# }

# # R2 Storage Module
# module "r2_storage" {
#   count  = var.enabled_modules["r2_storage"] ? 1 : 0
#   source = "./modules/r2_storage"

#   account_id = var.account_id
#   r2_buckets = try(var.r2_storage_config.buckets, [])
#   r2_custom_domains = try(var.r2_storage_config.custom_domains, [])
# }