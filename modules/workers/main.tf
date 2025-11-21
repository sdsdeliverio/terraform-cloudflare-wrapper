# Note: Workers resources have significant API changes in provider v5.8+
# Most resources are commented out until needed. Update to current API spec when activating.

# # Workers Script - API changed in v5.8+
# resource "cloudflare_workers_script" "script" {
#   for_each = { for script in var.workers_scripts : script.name => script }
#
#   account_id = var.account_id
#   # name changed to script_name in v5.8+
#   content    = each.value.content
#   # kv_namespace_binding and tags changed in v5.8+
# }

# Workers KV Namespace
resource "cloudflare_workers_kv_namespace" "namespace" {
  for_each = { for ns in var.kv_namespaces : ns.title => ns }

  account_id = var.account_id
  title      = each.key
}

# # Workers KV - API changed in v5.8+
# resource "cloudflare_workers_kv" "kv" {
#   for_each = { for kv in var.kv_pairs : "${kv.namespace_id}-${kv.key}" => kv }
#
#   account_id   = var.account_id
#   namespace_id = each.value.namespace_id
#   # key changed to key_name in v5.8+
#   value        = each.value.value
# }

# # Workers Route - API changed in v5.8+
# resource "cloudflare_workers_route" "route" {
#   for_each = { for route in var.workers_routes : "${route.zone_id}-${route.pattern}" => route }
#
#   zone_id     = each.value.zone_id
#   pattern     = each.value.pattern
#   # script_name argument removed in v5.8+
# }

# # Workers Custom Domain - API changed in v5.8+
# resource "cloudflare_workers_custom_domain" "domain" {
#   for_each = { for domain in var.custom_domains : domain.zone_id => domain }
#
#   account_id = var.account_id
#   # zone_id changed to zone in v5.8+
#   # hostname argument changed in v5.8+
#   # environment required in v5.8+
#   service    = each.value.service
# }

# # Workers Cron Trigger
# resource "cloudflare_workers_cron_trigger" "cron" {
#   for_each = { for trigger in var.cron_triggers : "${trigger.script_name}-${trigger.cron}" => trigger }
#
#   account_id  = var.account_id
#   script_name = each.value.script_name
#   schedules   = each.value.schedules
# }

