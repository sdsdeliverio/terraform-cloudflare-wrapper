variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "zones" {
  description = "Map of zones to manage"
  type = map(object({
    id   = string
    name = string
  }))
}

variable "tunnel_secret" {
  description = "Secret for Zero Trust tunnel"
  type        = string
  sensitive   = true
}

variable "admin_email" {
  description = "Admin email address for forwarding"
  type        = string
  default     = "admin@example.com"
}

variable "catchall_email" {
  description = "Catch-all email address"
  type        = string
  default     = "catchall@example.com"
}
