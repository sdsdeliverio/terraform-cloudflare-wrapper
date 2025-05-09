

# Pages Project
resource "cloudflare_pages_project" "project" {
  for_each = { for project in var.pages_projects : project.name => project }

  account_id        = var.account_id
  name              = each.key
  production_branch = try(each.value.production_branch, "main")

  dynamic "build_config" {
    for_each = try([each.value.build_config], [])
    content {
      build_command       = build_config.value.build_command
      destination_dir     = try(build_config.value.destination_dir, "public")
      root_dir           = try(build_config.value.root_dir, "")
      web_analytics_tag  = try(build_config.value.web_analytics_tag, "")
      web_analytics_token = try(build_config.value.web_analytics_token, "")
    }
  }
}

# Pages Domain
resource "cloudflare_pages_domain" "domain" {
  for_each = { for domain in var.pages_domains : "${domain.project_name}-${domain.domain}" => domain }

  account_id   = var.account_id
  project_name = each.value.project_name
  domain       = each.value.domain
}

# Custom Hostname
resource "cloudflare_custom_hostname" "hostname" {
  for_each = { for hostname in var.custom_hostnames : "${hostname.zone_id}-${hostname.hostname}" => hostname }

  zone_id     = each.value.zone_id
  hostname    = each.value.hostname
  ssl {
    method              = try(each.value.ssl_method, "http")
    type               = try(each.value.ssl_type, "dv")
    settings {
      http2            = try(each.value.enable_http2, true)
      min_tls_version  = try(each.value.min_tls_version, "1.2")
      tls13            = try(each.value.enable_tls13, true)
    }
  }
}

# Custom Pages
resource "cloudflare_custom_pages" "pages" {
  for_each = { for page in var.custom_pages : "${page.zone_id}-${page.type}" => page }

  zone_id = each.value.zone_id
  type    = each.value.type
  url     = each.value.url
  state   = try(each.value.state, "customized")
}

# Image Configuration
resource "cloudflare_image" "image" {
  for_each = { for img in var.images : "${img.account_id}-${img.name}" => img }

  account_id = each.value.account_id
  name       = each.value.name
  file_name  = each.value.file_name
  width      = try(each.value.width, null)
  height     = try(each.value.height, null)
  metadata   = try(each.value.metadata, {})
}

# Stream Configuration
resource "cloudflare_stream" "stream" {
  for_each = { for stream in var.streams : "${stream.account_id}-${stream.name}" => stream }

  account_id = each.value.account_id
  input {
    url = each.value.input_url
  }
  meta {
    name = each.value.name
  }
  watermark {
    uid        = try(each.value.watermark_uid, null)
    size       = try(each.value.watermark_size, 0.1)
    position   = try(each.value.watermark_position, "center")
    scale      = try(each.value.watermark_scale, true)
  }
}

