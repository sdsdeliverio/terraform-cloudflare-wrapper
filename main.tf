locals {
  common_tags = merge(
    var.tags,
    {
      environment = var.environment
      managed_by  = "terraform"
    }
  )
}

# resource "cloudflare_bot_management" "this" {
#   for_each           = { for zone in var.dns_networking_config.zones : zone.name => zone }
#   zone_id            = each.value.id
#   ai_bots_protection = var.cloudflare_bot_management.ai_bots_protection
#   fight_mode         = var.cloudflare_bot_management.fight_mode
#   enable_js          = var.cloudflare_bot_management.enable_js
#   crawler_protection = var.cloudflare_bot_management.crawler_protection
#   lifecycle {
#     prevent_destroy = true
#     # ignore_changes = [ 
#     #   "using_latest_model"
#     #  ]
#   }
# }

# # Account Authentication Module
# module "account_authentication" {
#   count  = var.enabled_modules["account_authentication"] ? 1 : 0
#   source = "./modules/account_authentication"

#   account_name   = try(var.account_auth_config.name, null)
#   account_type   = try(var.account_auth_config.type, "standard")
#   api_tokens     = try(var.account_auth_config.api_tokens, [])
#   account_members = try(var.account_auth_config.members, [])
# }

# DNS Networking Module
module "dns_networking" {
  count  = var.enabled_modules["dns_networking"] ? 1 : 0
  source = "./modules/dns_networking"

  environment = var.environment

  account_id = var.account_id
  zones      = var.zones
  records    = var.dns_networking_config.records

  dns_firewall_rules = try(var.dns_networking_config.firewall_rules, [])
}

# Email Management Module
module "email_management" {
  count  = var.enabled_modules["email_management"] ? 1 : 0
  source = "./modules/email_management"

  zones           = var.zones
  
  account_id  = var.account_id
  environment = var.environment

  catch_all_rule = try(var.email_management_config.catch_all_rule, null)

  aliasroute2email = try(var.email_management_config.aliasroute2email, [])

  depends_on = [module.dns_networking]
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
module "zero_trust_security" {
  count  = var.enabled_modules["zero_trust_security"] ? 1 : 0
  source = "./modules/zero_trust_security"

  zones              = var.dns_networking_config.zones
  default_zone_id    = var.dns_networking_config.zones[0].id
  environment        = var.environment
  account_id         = var.account_id
  cloudflare_secrets = var.cloudflare_secrets


  access_applications = try(var.zero_trust_config.access_applications, {})
  access_policies     = try(var.zero_trust_config.access_policies, {})
  tunnels             = try(var.zero_trust_config.tunnels, {})
  virtual_networks    = try(var.zero_trust_config.virtual_networks, {})
  gateway_policies    = try(var.zero_trust_config.gateway_policies, {})
}

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
