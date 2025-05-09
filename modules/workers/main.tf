

# Workers Script
resource "cloudflare_workers_script" "script" {
  for_each = { for script in var.workers_scripts : script.name => script }

  account_id = var.account_id
  name       = each.key
  content    = each.value.content
  
  dynamic "kv_namespace_binding" {
    for_each = try(each.value.kv_namespace_bindings, [])
    content {
      name         = kv_namespace_binding.value.name
      namespace_id = kv_namespace_binding.value.namespace_id
    }
  }

  tags = try(each.value.tags, [])
}

# Workers KV Namespace
resource "cloudflare_workers_kv_namespace" "namespace" {
  for_each = { for ns in var.kv_namespaces : ns.title => ns }

  account_id = var.account_id
  title      = each.key
}

# Workers KV
resource "cloudflare_workers_kv" "kv" {
  for_each = { for kv in var.kv_pairs : "${kv.namespace_id}-${kv.key}" => kv }

  account_id   = var.account_id
  namespace_id = each.value.namespace_id
  key          = each.value.key
  value        = each.value.value
}

# Workers Route
resource "cloudflare_workers_route" "route" {
  for_each = { for route in var.workers_routes : "${route.zone_id}-${route.pattern}" => route }

  zone_id     = each.value.zone_id
  pattern     = each.value.pattern
  script_name = each.value.script_name
}

# Workers Custom Domain
resource "cloudflare_workers_custom_domain" "domain" {
  for_each = { for domain in var.custom_domains : domain.zone_id => domain }

  account_id = var.account_id
  zone_id    = each.key
  hostname   = each.value.hostname
  service    = each.value.service
}

# Workers Cron Trigger
resource "cloudflare_workers_cron_trigger" "cron" {
  for_each = { for trigger in var.cron_triggers : "${trigger.script_name}-${trigger.cron}" => trigger }

  account_id  = var.account_id
  script_name = each.value.script_name
  schedules   = each.value.schedules
}

