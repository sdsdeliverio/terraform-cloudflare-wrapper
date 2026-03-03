# Note: Pages resources have API changes in provider v5.8+
# Commenting out problematic resources until needed.

# # Pages Project - build_config API changed in v5.8+
# resource "cloudflare_pages_project" "project" {
#   for_each = { for project in var.pages_projects : project.name => project }
#
#   account_id        = var.account_id
#   name              = each.key
#   production_branch = try(each.value.production_branch, "main")
#   # build_config structure changed in v5.8+
# }

# # Pages Domain - API changed, requires name field in v5.8+
# resource "cloudflare_pages_domain" "domain" {
#   for_each = { for domain in var.pages_domains : "${domain.project_name}-${domain.domain}" => domain }
#
#   account_id   = var.account_id
#   project_name = each.value.project_name
#   # name field required in v5.8+
#   domain       = each.value.domain
# }

# # Custom Hostname - ssl API changed in v5.8+
# resource "cloudflare_custom_hostname" "hostname" {
#   for_each = { for hostname in var.custom_hostnames : "${hostname.zone_id}-${hostname.hostname}" => hostname }
#
#   zone_id  = each.value.zone_id
#   hostname = each.value.hostname
#   # ssl structure changed from block to argument in v5.8+
# }

# # Custom Pages
# resource "cloudflare_custom_pages" "pages" {
#   for_each = { for page in var.custom_pages : "${page.zone_id}-${page.type}" => page }
#
#   zone_id = each.value.zone_id
#   type    = each.value.type
#   url     = each.value.url
#   state   = try(each.value.state, "customized")
# }

# Note: cloudflare_image and cloudflare_stream resources are deprecated or have
# significantly changed in provider v5.8+. These resources should be managed
# using the Cloudflare Images and Stream APIs directly or updated to match
# the current provider schema. They are commented out to prevent validation errors.

# # Image Configuration
# resource "cloudflare_image" "image" {
#   for_each = { for img in var.images : "${img.account_id}-${img.name}" => img }
#
#   account_id = each.value.account_id
#   name       = each.value.name
#   file_name  = each.value.file_name
#   width      = try(each.value.width, null)
#   height     = try(each.value.height, null)
#   metadata   = try(each.value.metadata, {})
# }

# # Stream Configuration
# resource "cloudflare_stream" "stream" {
#   for_each = { for stream in var.streams : "${stream.account_id}-${stream.name}" => stream }
#
#   account_id = each.value.account_id
#   input {
#     url = each.value.input_url
#   }
#   meta {
#     name = each.value.name
#   }
#   watermark {
#     uid      = try(each.value.watermark_uid, null)
#     size     = try(each.value.watermark_size, 0.1)
#     position = try(each.value.watermark_position, "center")
#     scale    = try(each.value.watermark_scale, true)
#   }
# }

