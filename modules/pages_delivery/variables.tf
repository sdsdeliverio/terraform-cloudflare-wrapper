# Variables for pages_delivery

variable "account_id" {
  description = "The account ID to manage resources for"
  type        = string
}

variable "pages_projects" {
  description = "List of Pages projects to manage"
  type = list(object({
    name              = string
    production_branch = optional(string, "main")
    build_config     = optional(object({
      build_command       = string
      destination_dir     = optional(string, "public")
      root_dir           = optional(string, "")
      web_analytics_tag  = optional(string, "")
      web_analytics_token = optional(string, "")
    }))
  }))
  default = []
}

variable "pages_domains" {
  description = "List of Pages domains to manage"
  type = list(object({
    project_name = string
    domain      = string
  }))
  default = []
}

variable "custom_hostnames" {
  description = "List of custom hostnames to manage"
  type = list(object({
    zone_id         = string
    hostname        = string
    ssl_method      = optional(string, "http")
    ssl_type        = optional(string, "dv")
    enable_http2    = optional(bool, true)
    min_tls_version = optional(string, "1.2")
    enable_tls13    = optional(bool, true)
  }))
  default = []
}

variable "custom_pages" {
  description = "List of custom pages to manage"
  type = list(object({
    zone_id = string
    type    = string
    url     = string
    state   = optional(string, "customized")
  }))
  default = []
}

variable "images" {
  description = "List of images to manage"
  type = list(object({
    account_id = string
    name       = string
    file_name  = string
    width      = optional(number)
    height     = optional(number)
    metadata   = optional(map(string), {})
  }))
  default = []
}

variable "streams" {
  description = "List of streams to manage"
  type = list(object({
    account_id         = string
    name              = string
    input_url         = string
    watermark_uid     = optional(string)
    watermark_size    = optional(number, 0.1)
    watermark_position = optional(string, "center")
    watermark_scale   = optional(bool, true)
  }))
  default = []
}
