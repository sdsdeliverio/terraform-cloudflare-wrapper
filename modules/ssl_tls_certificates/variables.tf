# Variables for ssl_tls_certificates

variable "certificate_packs" {
  description = "List of certificate packs to manage"
  type = list(object({
    zone_id           = string
    type             = string
    hosts            = list(string)
    validation_method = optional(string, "txt")
    validity_days    = optional(number, 90)
    wait_for_active  = optional(bool, true)
  }))
  default = []
}

variable "keyless_certificates" {
  description = "List of keyless certificates to manage"
  type = list(object({
    zone_id      = string
    certificate  = string
    name         = string
    host         = string
    port         = optional(number, 2407)
    bundle_method = optional(string, "ubiquitous")
  }))
  default = []
}

variable "origin_ca_certificates" {
  description = "List of origin CA certificates to manage"
  type = list(object({
    zone_id            = string
    csr               = string
    hostnames         = list(string)
    request_type      = optional(string, "origin-rsa")
    requested_validity = optional(number, 5475)
  }))
  default = []
}

variable "custom_ssl_configs" {
  description = "List of custom SSL configurations"
  type = list(object({
    zone_id      = string
    certificate  = string
    private_key  = string
    bundle_method = optional(string, "ubiquitous")
    type         = optional(string, "server")
    priority     = optional(number, 1)
  }))
  default = []
  sensitive = true
}

variable "zerotrust_mtls_certificates" {
  description = "List of Zero Trust MTLS certificates"
  type = list(object({
    zone_id      = string
    certificate  = string
    name         = string
    host         = string
    port         = optional(number, 2407)
    bundle_method = optional(string, "ubiquitous")
  }))
  default = []
}

variable "zerotrust_mtls_hostname_settings" {
  description = "List of Zero Trust MTLS hostname settings"
  type = list(object({
    zone_id     = string
    hostname    = string
    certificate = string
    private_key = string
    port        = optional(number, 2407)
  }))
  default = []
  sensitive = true
}
