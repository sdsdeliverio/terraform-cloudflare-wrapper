# Test for DNS networking module
run "basic_dns_record_creation" {
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
    records = [
      {
        zone_key = "example.com"
        records = [
          {
            name    = "www"
            type    = "A"
            content = "192.0.2.1"
            ttl     = 3600
            proxied = true
            comment = "Test record"
          }
        ]
      }
    ]
  }

  # Verify the DNS record is created
  assert {
    condition     = length(keys(cloudflare_dns_record.this)) == 1
    error_message = "Expected exactly one DNS record to be created"
  }
}

run "multiple_dns_records" {
  command = plan

  variables {
    environment = "test"
    account_id  = "test-account-id"
    zones = {
      "example.com" = {
        id   = "test-zone-id-1"
        name = "example.com"
      }
      "example.org" = {
        id   = "test-zone-id-2"
        name = "example.org"
      }
    }
    records = [
      {
        zone_key = "example.com"
        records = [
          {
            name    = "www"
            type    = "A"
            content = "192.0.2.1"
            ttl     = 3600
            proxied = true
          },
          {
            name    = "mail"
            type    = "MX"
            content = "mail.example.com"
            ttl     = 3600
            proxied = false
            priority = 10
          }
        ]
      },
      {
        zone_key = "example.org"
        records = [
          {
            name    = "www"
            type    = "A"
            content = "192.0.2.2"
            ttl     = 3600
            proxied = true
          }
        ]
      }
    ]
  }

  # Verify multiple DNS records are created
  assert {
    condition     = length(keys(cloudflare_dns_record.this)) == 3
    error_message = "Expected exactly three DNS records to be created"
  }
}

run "empty_records_list" {
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
    records = []
  }

  # Verify no DNS records are created when list is empty
  assert {
    condition     = length(keys(cloudflare_dns_record.this)) == 0
    error_message = "Expected no DNS records to be created when records list is empty"
  }
}
