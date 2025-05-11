# Variables for security_bot_management

variable "bot_management_zones" {
  description = "List of zones for bot management configuration"
  type = list(object({
    zone_id           = string
    enable_js         = optional(bool, true)
    fight_mode        = optional(bool, false)
    optimization_type = optional(string, "balanced")
  }))
  default = []
}

variable "firewall_rules" {
  description = "List of firewall rules to manage"
  type = list(object({
    zone_id     = string
    description = string
    filter_id   = string
    action      = string
    priority    = optional(number)
    paused      = optional(bool, false)
  }))
  default = []
}

variable "ua_blocking_rules" {
  description = "List of user agent blocking rules"
  type = list(object({
    zone_id     = string
    description = string
    mode        = string
    paused      = optional(bool, false)
    target      = string
    value       = string
  }))
  default = []
}

variable "page_shield_policies" {
  description = "List of page shield policies"
  type = list(object({
    zone_id = string
    name    = string
    action  = string
    enabled = optional(bool, true)
  }))
  default = []
}

variable "authenticated_origin_pulls" {
  description = "List of zones for authenticated origin pulls"
  type = list(object({
    zone_id = string
    enabled = bool
  }))
  default = []
}

variable "origin_pull_certificates" {
  description = "List of authenticated origin pull certificates"
  type = list(object({
    zone_id     = string
    certificate = string
    private_key = string
    type        = optional(string, "per-zone")
  }))
  default   = []
  sensitive = true
}
