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

# Note: enforce_twofactor is deprecated in provider v5.8+ and has been removed

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

variable "internal_dns_view_name" {
  description = "Name for the internal DNS view"
  type        = string
  default     = "internal_view"
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
    zone_id                 = string
    auth_id_characteristics = optional(list(string), [])
  }))
  default = []
}

variable "api_shield_schemas" {
  description = "List of API Shield schemas"
  type = list(object({
    zone_id = string
    name    = string
    kind    = string
    file    = string # Changed from validation to file in provider v5.8+
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
