# Variables for zero_trust_security

variable "account_id" {
  description = "The account ID to manage resources for"
  type        = string
}

variable "access_applications" {
  description = "List of Access applications to manage"
  type = list(object({
    name             = string
    domain           = string
    zone_id          = optional(string)
    type             = optional(string, "self_hosted")
    session_duration = optional(string, "24h")
  }))
  default = []
}

variable "access_policies" {
  description = "List of Access policies to manage"
  type = list(object({
    application_id = string
    zone_id       = optional(string)
    name          = string
    precedence    = number
    decision      = string
    include = object({
      email = optional(list(string))
      group = optional(list(string))
    })
  }))
  default = []
}

variable "access_groups" {
  description = "List of Access groups to manage"
  type = list(object({
    name    = string
    include = object({
      email  = optional(list(string))
      emails = optional(list(string))
      group  = optional(list(string))
    })
  }))
  default = []
}

variable "gateway_policies" {
  description = "List of Zero Trust Gateway policies"
  type = list(object({
    name    = string
    enabled = optional(bool, true)
    rules   = list(object({
      name            = string
      action          = string
      enabled         = optional(bool, true)
      filters         = list(string)
      traffic         = list(string)
      identity        = optional(list(string), [])
      device_posture = optional(list(string), [])
    }))
  }))
  default = []
}

variable "gateway_settings" {
  description = "List of Zero Trust Gateway settings"
  type = list(object({
    account_id                = string
    antivirus_enabled_download = optional(bool, true)
    antivirus_enabled_upload  = optional(bool, true)
    antivirus_fail_closed    = optional(bool, true)
    tls_decrypt_enabled      = optional(bool, true)
  }))
  default = []
}

variable "tunnels" {
  description = "List of Zero Trust tunnels"
  type = list(object({
    name   = string
    secret = string
  }))
  default = []
  sensitive = true
}

variable "virtual_networks" {
  description = "List of Zero Trust virtual networks"
  type = list(object({
    name               = string
    is_default_network = optional(bool, false)
    comment           = optional(string)
  }))
  default = []
}
