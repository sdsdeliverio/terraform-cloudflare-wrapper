variable "cloudflare_api_token" {
  description = "The API token for Cloudflare authentication"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "The Cloudflare account ID"
  type        = string
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Module enablement flags
variable "enabled_modules" {
  description = "Map of modules to enable/disable"
  type        = map(bool)
  default = {
    account_authentication  = false
    dns_networking          = false
    security_bot_management = false
    ssl_tls_certificates    = false
    workers                 = false
    zero_trust_security     = false
    pages_delivery          = false
    r2_storage              = false
  }
}

variable "dns_networking_config" {
  description = "List of zones and their DNS records configurations"
  type = object({
    zones = list(object({
      name                 = string
      id                   = string
      paused               = optional(bool, false)
      plan                 = optional(string, "free")
      type                 = optional(string, "full")
      dns_settings_enabled = optional(bool, true)
      enable_dnssec        = optional(bool, false)
    }))
    records = optional(list(object({
      zone_key = string
      records = list(object({
        name     = string
        type     = string
        content  = string
        ttl      = number
        proxied  = optional(bool, false)
        priority = optional(number)
        comment  = optional(string, "Managed by Terraform")
      }))
    })), [])
  })
  default = {
    zones = [],
    records = []
  }
}

variable "cloudflare_bot_management" {
  description = "Bot management configuration"
  type = object({
    ai_bots_protection = optional(string, "block")
    fight_mode         = optional(bool, true)
    enable_js          = optional(bool, true)
  })
  default = {
    ai_bots_protection = "block"
    fight_mode         = true
    enable_js          = true
  }
}

# Security Bot Management Module Variables
variable "security_bot_config" {
  description = "Configuration for the security and bot management module"
  type        = any
  default     = {}
}

# SSL/TLS Certificates Module Variables
variable "ssl_tls_config" {
  description = "Configuration for the SSL/TLS certificates module"
  type        = any
  default     = {}
}

# Workers Module Variables
variable "workers_config" {
  description = "Configuration for the Workers module"
  type        = any
  default     = {}
}

# Zero Trust Security Module Variables
variable "zero_trust_config" {
  description = "Configuration for the Zero Trust security module"
  type        = any
  default     = {}
}

# Pages Delivery Module Variables
variable "pages_delivery_config" {
  description = "Configuration for the Pages delivery module"
  type        = any
  default     = {}
}

# R2 Storage Module Variables
variable "r2_storage_config" {
  description = "Configuration for the R2 storage module"
  type        = any
  default     = {}
}
