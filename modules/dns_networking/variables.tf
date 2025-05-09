# Variables for dns_networking

variable "account_id" {
  description = "The account ID to manage resources for"
  type        = string
}

variable "zone" {
  type = object({
    name = string
    id   = string
  })
  description = "Zone Id & Name"
}

variable "cloudflare_bot_management" {
  type = object({
    ai_bots_protection = optional(string, "block")
    fight_mode        = optional(bool, true)
    enable_js         = optional(bool, true)
  })
  description = "CF Bot Management Configs"
}

variable "records" {
  type = list(object({
    name     = string
    type     = string
    value    = string
    ttl      = optional(number, 1)
    proxied  = optional(bool, true)
    priority = optional(number)
    comment  = optional(string)
  }))
  description = "List of DNS records to manage."
}

variable "zones" {
  description = "List of DNS zones to manage"
  type = list(object({
    name                = string
    paused             = optional(bool, false)
    plan               = optional(string, "free")
    type               = optional(string, "full")
    dns_settings_enabled = optional(bool, true)
    enable_dnssec      = optional(bool, false)
  }))
}

variable "dns_records" {
  description = "List of DNS records to manage"
  type = list(object({
    zone_name = string
    name      = string
    type      = string
    content   = string
    ttl       = optional(number, 1)
    proxied   = optional(bool, true)
    priority  = optional(number)
  }))
  default = []
}

variable "dns_firewall_rules" {
  description = "List of DNS firewall rules"
  type = list(object({
    zone_name = string
    name      = string
    rules     = list(any)
  }))
  default = []
}

variable "zone_transfers_acls" {
  description = "List of zone transfer ACLs"
  type = list(object({
    zone_name  = string
    name       = string
    source_ips = list(string)
  }))
  default = []
}

variable "address_maps" {
  description = "List of address maps to manage"
  type = list(object({
    account_id = string
    prefix     = string
    enabled    = optional(bool, true)
    ips        = list(string)
  }))
  default = []
}
