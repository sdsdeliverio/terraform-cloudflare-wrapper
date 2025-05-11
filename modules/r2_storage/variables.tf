# Variables for r2_storage

variable "account_id" {
  description = "The account ID to manage resources for"
  type        = string
}

variable "r2_buckets" {
  description = "List of R2 buckets to manage"
  type = list(object({
    name     = string
    location = optional(string, "WEUR")
    cors_rules = optional(list(object({
      allowed_origins = list(string)
      allowed_methods = list(string)
      allowed_headers = optional(list(string), [])
      exposed_headers = optional(list(string), [])
      max_age_seconds = optional(number, 600)
    })))
    lifecycle_rules = optional(list(object({
      enabled         = optional(bool, true)
      expiration_days = number
      prefix          = optional(string, "")
      tags            = optional(map(string), {})
    })))
  }))
  default = []
}

variable "r2_custom_domains" {
  description = "List of R2 custom domains"
  type = list(object({
    custom_domain = string
    bucket        = string
  }))
  default = []
}

variable "r2_managed_domains" {
  description = "List of R2 managed domains"
  type = list(object({
    zone_id = string
    domain  = string
    bucket  = string
  }))
  default = []
}
