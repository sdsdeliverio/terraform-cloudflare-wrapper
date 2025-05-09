terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Configure provider alias for modules if needed
provider "cloudflare" {
  alias     = "main"
  api_token = var.cloudflare_api_token
}