# # Account Authentication outputs
# output "account_auth" {
#   description = "Account authentication module outputs"
#   value = var.enabled_modules["account_authentication"] ? {
#     account_id = module.account_authentication[0].account_id
#     api_tokens = module.account_authentication[0].api_tokens
#   } : null
#   sensitive = true
# }

# # DNS Networking outputs
# output "dns_networking" {
#   description = "DNS networking module outputs"
#   value = var.enabled_modules["dns_networking"] ? {
#     zones = module.dns_networking[0].zones
#     records = module.dns_networking[0].dns_records
#   } : null
# }

# # Security Bot Management outputs
# output "security_bot" {
#   description = "Security and bot management module outputs"
#   value = var.enabled_modules["security_bot_management"] ? {
#     firewall_rules = module.security_bot_management[0].firewall_rules
#     bot_management = module.security_bot_management[0].bot_management
#   } : null
# }

# # SSL/TLS Certificates outputs
# output "ssl_tls" {
#   description = "SSL/TLS certificates module outputs"
#   value = var.enabled_modules["ssl_tls_certificates"] ? {
#     certificates = module.ssl_tls_certificates[0].certificates
#     custom_hostnames = module.ssl_tls_certificates[0].custom_hostnames
#   } : null
#   sensitive = true
# }

# # Workers outputs
# output "workers" {
#   description = "Workers module outputs"
#   value = var.enabled_modules["workers"] ? {
#     scripts = module.workers[0].scripts
#     routes = module.workers[0].routes
#     kv_namespaces = module.workers[0].kv_namespaces
#   } : null
# }

# # Zero Trust Security outputs
# output "zero_trust" {
#   description = "Zero Trust security module outputs"
#   value = var.enabled_modules["zero_trust_security"] ? {
#     applications = module.zero_trust_security[0].applications
#     policies = module.zero_trust_security[0].policies
#     tunnels = module.zero_trust_security[0].tunnels
#   } : null
#   sensitive = true
# }

# # Pages Delivery outputs
# output "pages_delivery" {
#   description = "Pages delivery module outputs"
#   value = var.enabled_modules["pages_delivery"] ? {
#     projects = module.pages_delivery[0].projects
#     domains = module.pages_delivery[0].domains
#   } : null
# }

# # R2 Storage outputs
# output "r2_storage" {
#   description = "R2 storage module outputs"
#   value = var.enabled_modules["r2_storage"] ? {
#     buckets = module.r2_storage[0].buckets
#     custom_domains = module.r2_storage[0].custom_domains
#   } : null
# }