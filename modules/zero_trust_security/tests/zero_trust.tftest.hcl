# Test for zero trust security module
run "basic_tunnel_creation" {
  command = plan

  variables {
    environment = "test"
    account_id  = "test-account-id"
    zones = {
      "example.com" = {
        id   = "test-zone-id-1"
        name = "example.com"
      }
    }
    cloudflare_secrets = {
      tunnel_secrets = {
        "test-tunnel" = {
          secret = "test-secret"
        }
      }
    }
    tunnels = {
      "test-tunnel" = {
        name       = "test-tunnel"
        config_src = "cloudflare"
        routes     = []
      }
    }
    virtual_networks    = {}
    access_applications = {}
    access_policies     = {}
    gateway_policies    = {}
    lists               = {}
    firewall_ruleset    = {}
  }

  # Verify the tunnel is created
  assert {
    condition     = length(keys(cloudflare_zero_trust_tunnel_cloudflared.this)) == 1
    error_message = "Expected exactly one tunnel to be created"
  }
}

run "virtual_network_creation" {
  command = plan

  variables {
    environment = "test"
    account_id  = "test-account-id"
    zones       = {}
    cloudflare_secrets = {
      tunnel_secrets = {}
    }
    tunnels = {}
    virtual_networks = {
      "test-vnet" = {
        is_default_network = true
        comment            = "Test virtual network"
      }
    }
    access_applications = {}
    access_policies     = {}
    gateway_policies    = {}
    lists               = {}
    firewall_ruleset    = {}
  }

  # Verify the virtual network is created
  assert {
    condition     = length(keys(cloudflare_zero_trust_tunnel_cloudflared_virtual_network.this)) == 1
    error_message = "Expected exactly one virtual network to be created"
  }
}

run "access_policy_creation" {
  command = plan

  variables {
    environment         = "test"
    account_id          = "test-account-id"
    zones               = {}
    cloudflare_secrets  = {}
    tunnels             = {}
    virtual_networks    = {}
    access_applications = {}
    access_policies = {
      "test-policy" = {
        name     = "test-policy"
        decision = "allow"
        include = [
          {
            everyone = {}
          }
        ]
      }
    }
    gateway_policies = {}
    lists            = {}
    firewall_ruleset = {}
  }

  # Verify the access policy is created
  assert {
    condition     = length(keys(cloudflare_zero_trust_access_policy.this)) == 1
    error_message = "Expected exactly one access policy to be created"
  }
}

run "zero_trust_list_creation" {
  command = plan

  variables {
    environment         = "test"
    account_id          = "test-account-id"
    zones               = {}
    cloudflare_secrets  = {}
    tunnels             = {}
    virtual_networks    = {}
    access_applications = {}
    access_policies     = {}
    gateway_policies    = {}
    lists = {
      "test-list" = {
        name        = "test-list"
        type        = "IP"
        description = "Test IP list"
        items = [
          {
            value       = "192.0.2.1"
            description = "Test IP"
          }
        ]
      }
    }
    firewall_ruleset = {}
  }

  # Verify the list is created
  assert {
    condition     = length(keys(cloudflare_zero_trust_list.this)) == 1
    error_message = "Expected exactly one list to be created"
  }
}
