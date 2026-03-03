# Complete Example

This example demonstrates a complete configuration using the DNS, Email, and Zero Trust modules.

## Prerequisites

- Terraform >= 1.0.0
- Cloudflare account with API token
- Existing Cloudflare zones (or create them separately)

## Usage

1. Copy this example to your own directory
2. Create a `terraform.tfvars` file with your values:

```hcl
cloudflare_api_token = "your-api-token"
account_id           = "your-account-id"
tunnel_secret        = "your-tunnel-secret"

zones = {
  "example.com" = {
    id   = "your-zone-id-1"
    name = "example.com"
  }
  "example.org" = {
    id   = "your-zone-id-2"
    name = "example.org"
  }
}
```

3. Run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## What This Example Creates

### DNS Resources
- A record for www.example.com (proxied)
- A record for api.example.com (proxied)
- MX record for mail handling
- CNAME record for subdomain

### Email Routing
- Forward info@example.com to admin@example.com
- Drop spam@example.com
- Catch-all rule forwarding to catchall@example.com

### Zero Trust
- Virtual network for private routing
- Tunnel for accessing internal services
- Access application for internal app
- Access policy allowing team members
- IP allow list

## Cost Considerations

Most resources in this example are available on Cloudflare's free plan, except:
- Zero Trust features may require Teams plan
- Advanced email routing features may have limits

Check Cloudflare's pricing before applying.
