output "access_applications_aud_tags" {
  description = "Map of access application audience tags"
  value = {
    for app_key, app in cloudflare_zero_trust_access_application.this : app_key => app.aud
  }
}

output "tunnels" {
  description = "Map of created tunnels"
  value = {
    for tunnel_key, tunnel in cloudflare_zero_trust_tunnel_cloudflared.this : tunnel_key => {
      id   = tunnel.id
      name = tunnel.name
    }
  }
}

output "virtual_networks" {
  description = "Map of created virtual networks"
  value = {
    for vnet_key, vnet in cloudflare_zero_trust_tunnel_cloudflared_virtual_network.this : vnet_key => {
      id   = vnet.id
      name = vnet.name
    }
  }
}

output "access_policies" {
  description = "Map of created access policies"
  value = {
    for policy_key, policy in cloudflare_zero_trust_access_policy.this : policy_key => {
      id   = policy.id
      name = policy.name
    }
  }
}

output "gateway_policies" {
  description = "Map of created gateway policies"
  value = {
    for policy_key, policy in cloudflare_zero_trust_gateway_policy.this : policy_key => {
      id   = policy.id
      name = policy.name
    }
  }
}

output "lists" {
  description = "Map of created Zero Trust lists"
  value = {
    for list_key, list in cloudflare_zero_trust_list.this : list_key => {
      id   = list.id
      name = list.name
    }
  }
}

