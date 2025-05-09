# Variables for account_authentication

variable "account_name" {
  description = "Name of the Cloudflare account"
  type        = string
}

variable "account_type" {
  description = "Type of Cloudflare account"
  type        = string
  default     = "standard"
}

variable "enforce_twofactor" {
  description = "Whether to enforce two-factor authentication"
  type        = bool
  default     = true
}

variable "dns_settings_enabled" {
  description = "Whether to enable account-level DNS settings"
  type        = bool
  default     = true
}

variable "internal_dns_enabled" {
  description = "Whether to enable internal DNS view"
  type        = bool
  default     = false
}

variable "account_members" {
  description = "List of account members to manage"
  type = list(object({
    email    = string
    role_ids = list(string)
  }))
  default = []
}

variable "subscription_rate_plan" {
  description = "Rate plan for the account subscription"
  type        = string
  default     = "FREE"
}

variable "api_tokens" {
  description = "List of API tokens to create"
  type = list(object({
    name        = string
    permissions = list(string)
    resources   = map(string)
  }))
  default = []
}

variable "api_shield_zones" {
  description = "List of zones to enable API Shield"
  type = list(object({
    zone_id = string
    enabled = bool
  }))
  default = []
}

variable "api_shield_schemas" {
  description = "List of API Shield schemas"
  type = list(object({
    zone_id    = string
    name       = string
    kind       = string
    validation = string
  }))
  default = []
}

variable "api_shield_operations" {
  description = "List of API Shield operations"
  type = list(object({
    zone_id  = string
    endpoint = string
    method   = string
    host     = string
  }))
  default = []
}
