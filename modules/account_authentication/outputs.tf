output "account_id" {
  description = "The ID of the created Cloudflare account"
  value       = cloudflare_account.account.id
}

# Note: Outputs below are commented out as the corresponding resources are commented out
# due to API changes in provider v5.8+. Uncomment when resources are activated.

# output "api_tokens" {
#   description = "Map of created API tokens"
#   value       = { for k, v in cloudflare_api_token.token : k => v.id }
#   sensitive   = true
# }

# output "account_members" {
#   description = "Map of account members"
#   value       = { for k, v in cloudflare_account_member.members : k => v.id }
# }

output "api_shield" {
  description = "Map of API Shield configurations"
  value       = { for k, v in cloudflare_api_shield.shield : k => v.id }
}

output "api_shield_schemas" {
  description = "Map of API Shield schemas"
  value       = { for k, v in cloudflare_api_shield_schema.schemas : k => v.name }
}