terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.8.2"
    }
  }
}

# R2 Bucket
resource "cloudflare_r2_bucket" "bucket" {
  for_each = { for bucket in var.r2_buckets : bucket.name => bucket }

  account_id = var.account_id
  name       = each.key
  location   = try(each.value.location, "WEUR")
}

# R2 Bucket CORS Configuration
resource "cloudflare_r2_bucket_cors" "cors" {
  for_each = { for bucket in var.r2_buckets : bucket.name => bucket if try(bucket.cors_rules, null) != null }

  account_id = var.account_id
  bucket     = cloudflare_r2_bucket.bucket[each.key].name
  dynamic "cors_rule" {
    for_each = each.value.cors_rules
    content {
      allowed_origins = cors_rule.value.allowed_origins
      allowed_methods = cors_rule.value.allowed_methods
      allowed_headers = try(cors_rule.value.allowed_headers, [])
      exposed_headers = try(cors_rule.value.exposed_headers, [])
      max_age_seconds = try(cors_rule.value.max_age_seconds, 600)
    }
  }
}

# R2 Bucket Lifecycle Configuration
resource "cloudflare_r2_bucket_lifecycle" "lifecycle" {
  for_each = { for bucket in var.r2_buckets : bucket.name => bucket if try(bucket.lifecycle_rules, null) != null }

  account_id = var.account_id
  bucket     = cloudflare_r2_bucket.bucket[each.key].name
  dynamic "rule" {
    for_each = each.value.lifecycle_rules
    content {
      enabled = try(rule.value.enabled, true)
      expiration {
        days = rule.value.expiration_days
      }
      filter {
        prefix = try(rule.value.prefix, "")
        tags   = try(rule.value.tags, {})
      }
    }
  }
}

# R2 Custom Domain
resource "cloudflare_r2_custom_domain" "domain" {
  for_each = { for domain in var.r2_custom_domains : domain.custom_domain => domain }

  account_id    = var.account_id
  custom_domain = each.key
  bucket        = each.value.bucket
}

# R2 Managed Domain
resource "cloudflare_r2_managed_domain" "managed" {
  for_each = { for domain in var.r2_managed_domains : domain.zone_id => domain }

  account_id = var.account_id
  zone_id    = each.key
  domain     = each.value.domain
  bucket     = each.value.bucket
}

