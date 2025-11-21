# Note: Resources in this module are commented out due to API changes in provider v5.8+
# Uncomment and update when needed for production use.

# # Certificate Pack - API changed in v5.8+
# resource "cloudflare_certificate_pack" "cert_pack" {
#   for_each = { for pack in var.certificate_packs : "${pack.zone_id}-${pack.type}" => pack }
#
#   zone_id           = each.value.zone_id
#   type              = each.value.type
#   hosts             = each.value.hosts
#   validation_method = try(each.value.validation_method, "txt")
#   validity_days     = try(each.value.validity_days, 90)
#   # wait_for_active removed, certificate_authority required in v5.8+
# }

# Keyless Certificate
resource "cloudflare_keyless_certificate" "keyless" {
  for_each = { for cert in var.keyless_certificates : "${cert.zone_id}-${cert.certificate}" => cert }

  zone_id       = each.value.zone_id
  certificate   = each.value.certificate
  name          = each.value.name
  host          = each.value.host
  port          = try(each.value.port, 2407)
  bundle_method = try(each.value.bundle_method, "ubiquitous")
}

# # Origin CA Certificate - API changed in v5.8+
# resource "cloudflare_origin_ca_certificate" "origin" {
#   for_each = { for cert in var.origin_ca_certificates : "${cert.zone_id}-${cert.hostnames[0]}" => cert }
#
#   # zone_id removed in v5.8+
#   csr                = each.value.csr
#   hostnames          = each.value.hostnames
#   request_type       = try(each.value.request_type, "origin-rsa")
#   requested_validity = try(each.value.requested_validity, 5475)
# }

# # Custom SSL - sensitive value issues and API changed in v5.8+
# resource "cloudflare_custom_ssl" "custom" {
#   for_each = { for ssl in var.custom_ssl_configs : "${ssl.zone_id}-${ssl.certificate}" => ssl }
#
#   zone_id       = each.value.zone_id
#   certificate   = each.value.certificate
#   private_key   = each.value.private_key
#   bundle_method = try(each.value.bundle_method, "ubiquitous")
#   type          = try(each.value.type, "server")
#   # priority is read-only in v5.8+
# }

# # Zero Trust Access MTLS Certificate - API changed in v5.8+
# resource "cloudflare_zero_trust_access_mtls_certificate" "mtls_cert" {
#   for_each = { for cert in var.zerotrust_mtls_certificates : "${cert.zone_id}-${cert.certificate}" => cert }
#
#   zone_id       = each.value.zone_id
#   certificate   = each.value.certificate
#   name          = each.value.name
#   # host, port, bundle_method removed in v5.8+
# }

# # Zero Trust Access MTLS Hostname Settings - API changed significantly in v5.8+
# resource "cloudflare_zero_trust_access_mtls_hostname_settings" "mtls_hostname" {
#   for_each = { for setting in var.zerotrust_mtls_hostname_settings : "${setting.zone_id}-${setting.hostname}" => setting }
#
#   zone_id     = each.value.zone_id
#   # settings structure required in v5.8+
# }

