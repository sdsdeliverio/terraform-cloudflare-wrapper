# Variables for workers

variable "account_id" {
  description = "The account ID to manage resources for"
  type        = string
}

variable "workers_scripts" {
  description = "List of worker scripts to deploy"
  type = list(object({
    name    = string
    content = string
    kv_namespace_bindings = optional(list(object({
      name         = string
      namespace_id = string
    })), [])
    tags = optional(list(string), [])
  }))
  default = []
}

variable "kv_namespaces" {
  description = "List of KV namespaces to create"
  type = list(object({
    title = string
  }))
  default = []
}

variable "kv_pairs" {
  description = "List of KV pairs to manage"
  type = list(object({
    namespace_id = string
    key          = string
    value        = string
  }))
  default = []
}

variable "workers_routes" {
  description = "List of worker routes to manage"
  type = list(object({
    zone_id     = string
    pattern     = string
    script_name = string
  }))
  default = []
}

variable "custom_domains" {
  description = "List of custom domains for workers"
  type = list(object({
    zone_id  = string
    hostname = string
    service  = string
  }))
  default = []
}

variable "cron_triggers" {
  description = "List of cron triggers for workers"
  type = list(object({
    script_name = string
    schedules   = list(string)
  }))
  default = []
}
