variable "cloudflare_api_token" {
  description = "The API token for Cloudflare authentication"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {
    managed_by = "terraform"
  }
}

variable "enabled_modules" {
  description = "Map of modules to enable"
  type        = map(bool)
  default     = {
    account_authentication  = true
    dns_networking         = true
    security_bot_management = true
    ssl_tls_certificates   = true
    workers               = true
    zero_trust_security    = true
    pages_delivery        = true
    r2_storage            = true
  }
}