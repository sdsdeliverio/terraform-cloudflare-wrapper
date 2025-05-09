terraform {
  required_version = ">= 5.4.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.4.0"  
    }
  }
}