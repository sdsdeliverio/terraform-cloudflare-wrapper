# Variables for dns_networking

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "production"
}

variable "account_id" {
  description = "The account ID to manage resources for"
  type        = string
}

variable "zones" {
  description = "List of DNS zones to manage"
  type = map(object({
    name = string
    id   = string
  }))
}

variable "catch_all_rule" {
  description = "Catch all rule for email routing"
  type = object({
    catchall_email = optional(string)
    zone_key       = optional(string)
  })
  default = null
}

# variable "aliasroute2worker" {
#   description = "List of DNS zones to manage"
#   type = list(object({
#     alias          = string
#     email_to_route = string
#   }))
# }

variable "aliasroute2email" {
  description = "List Aliases to route emails"
  type = list(object({
    alias          = string
    email_to_route = optional(string)
    action         = optional(string, "forward")
    zone_key       = optional(string)
  }))
}