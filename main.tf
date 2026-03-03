locals {
  common_tags = merge(
    var.tags,
    {
      environment = var.environment
      managed_by  = "terraform"
    }
  )
}

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

  zones = var.zones

  account_id  = var.account_id
  environment = var.environment

  catch_all_rule = try(var.email_management_config.catch_all_rule, null)

  aliasroute2email = try(var.email_management_config.aliasroute2email, [])

  depends_on = [module.dns_networking]
}

# Zero Trust Security Module
module "zero_trust_security" {
  count  = var.enabled_modules["zero_trust_security"] ? 1 : 0
  source = "./modules/zero_trust_security"

  zones = var.zones

  environment        = var.environment
  account_id         = var.account_id
  cloudflare_secrets = var.cloudflare_secrets


  access_applications = try(var.zero_trust_config.access_applications, {})
  access_policies     = try(var.zero_trust_config.access_policies, {})
  tunnels             = try(var.zero_trust_config.tunnels, {})
  virtual_networks    = try(var.zero_trust_config.virtual_networks, {})
  gateway_policies    = try(var.zero_trust_config.gateway_policies, {})
  lists               = try(var.zero_trust_config.lists, {})
  firewall_ruleset    = try(var.zero_trust_config.firewall_ruleset, {})
}

