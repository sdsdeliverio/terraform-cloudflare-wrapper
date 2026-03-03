# Test for email management module
run "basic_email_forwarding" {
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
    aliasroute2email = [
      {
        alias          = "info"
        action         = "forward"
        email_to_route = "admin@example.com"
        zone_key       = "example.com"
      }
    ]
    catch_all_rule = null
  }

  # Verify the email routing address is created
  assert {
    condition     = length(keys(cloudflare_email_routing_address.this)) >= 1
    error_message = "Expected at least one email routing address to be created"
  }

  # Verify the forwarding rule is created
  assert {
    condition     = length(keys(cloudflare_email_routing_rule.forwarding)) == 1
    error_message = "Expected exactly one forwarding rule to be created"
  }
}

run "catch_all_rule" {
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
    aliasroute2email = []
    catch_all_rule = {
      zone_key       = "example.com"
      catchall_email = "catchall@example.com"
    }
  }

  # Verify the catch-all rule is created
  assert {
    condition     = length(cloudflare_email_routing_catch_all.this) == 1
    error_message = "Expected exactly one catch-all rule to be created"
  }
}

run "drop_email_rule" {
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
    aliasroute2email = [
      {
        alias          = "spam"
        action         = "drop"
        email_to_route = ""
        zone_key       = "example.com"
      }
    ]
    catch_all_rule = null
  }

  # Verify the drop rule is created
  assert {
    condition     = length(keys(cloudflare_email_routing_rule.drop)) == 1
    error_message = "Expected exactly one drop rule to be created"
  }
}
