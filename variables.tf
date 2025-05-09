variable "cloudflare_api_token" {
  description = "The API token for Cloudflare authentication"
  type        = string
  sensitive   = true
}

variable "module_enabled" {
  description = "Whether to create the module's resources"
  type        = bool
  default     = true
}

variable "module_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}