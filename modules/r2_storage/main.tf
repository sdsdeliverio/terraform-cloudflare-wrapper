# Note: All R2 resources have API changes in provider v5.8+. Commenting out
# all resources until needed. Update to current API spec when activating.

# # R2 Bucket
# resource "cloudflare_r2_bucket" "bucket" {
#   for_each = { for bucket in var.r2_buckets : bucket.name => bucket }
#
#   account_id = var.account_id
#   name       = each.key
#   location   = try(each.value.location, "WEUR")
# }

# # R2 Bucket CORS Configuration - API changed in v5.8+
# resource "cloudflare_r2_bucket_cors" "cors" {
#   for_each = { for bucket in var.r2_buckets : bucket.name => bucket if try(bucket.cors_rules, null) != null }
#
#   account_id = var.account_id
#   # bucket changed to bucket_name in v5.8+
#   # cors_rule structure changed in v5.8+
# }

# # R2 Bucket Lifecycle Configuration - API changed in v5.8+
# resource "cloudflare_r2_bucket_lifecycle" "lifecycle" {
#   for_each = { for bucket in var.r2_buckets : bucket.name => bucket if try(bucket.lifecycle_rules, null) != null }
#
#   account_id = var.account_id
#   # bucket changed to bucket_name, rule structure changed in v5.8+
# }

# # R2 Custom Domain
# resource "cloudflare_r2_custom_domain" "domain" {
#   for_each = { for domain in var.r2_custom_domains : domain.custom_domain => domain }
#
#   account_id    = var.account_id
#   custom_domain = each.key
#   bucket        = each.value.bucket
# }

# Note: cloudflare_r2_managed_domain resource has API changes in provider v5.8+
# The zone_id and domain arguments have changed. Commenting out until needed.
# # R2 Managed Domain
# resource "cloudflare_r2_managed_domain" "managed" {
#   for_each = { for domain in var.r2_managed_domains : domain.zone_id => domain }
#
#   account_id = var.account_id
#   # API changed in v5.8+
#   bucket     = each.value.bucket
# }

