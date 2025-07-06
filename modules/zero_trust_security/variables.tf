# Variables for zero_trust_security

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "production"
}

variable "account_id" {
  description = "The Account ID to manage resources"
  type        = string
}

variable "access_applications" {
  description = "Map of Cloudflare Access Applications"
  type = map(object({
    name                        = string
    domain                      = string
    type                        = string
    allowed_idps                = optional(list(string), null)
    app_launcher_visible        = optional(bool, null)
    allow_authenticate_via_warp = optional(bool, true)
    auto_redirect_to_identity   = optional(bool, null)
    cors_headers = optional(object({
      allow_all_headers = optional(bool, false)
      allow_all_methods = optional(bool, false)
      allow_all_origins = optional(bool, false)
      allow_credentials = optional(bool)
      allowed_headers   = list(string)
      allowed_methods   = list(string)
      allowed_origins   = list(string)
      max_age           = number
    }), null)
    custom_deny_message          = optional(string, null)
    custom_deny_url              = optional(string, null)
    custom_non_identity_deny_url = optional(string, null)
    custom_pages                 = optional(list(string), null)
    destinations = optional(list(object({
      type        = string
      uri         = optional(string)
      cidr        = optional(string)
      hostname    = optional(string)
      l4_protocol = optional(string)
      port_range  = optional(string)
      vnet_id     = optional(string)
    })), null)
    enable_binding_cookie           = optional(bool, true)
    http_only_cookie_attribute      = optional(bool, true)
    logo_url                        = optional(string, null)
    options_preflight_bypass        = optional(bool, true)
    path_cookie_attribute           = optional(bool, true)
    policies                        = optional(list(string), [])
    read_service_tokens_from_header = optional(string, null)
    same_site_cookie_attribute      = optional(string, null)
    scim_config = optional(object({
      idp_uid    = string
      remote_uri = string
      authentication = object({
        user     = string
        password = string
        scheme   = string
      })
      deactivate_on_delete = bool
      enabled              = bool
      mappings = list(object({
        schema  = string
        enabled = bool
        filter  = string
        operations = object({
          create = bool
          delete = bool
          update = bool
        })
        strictness        = string
        transform_jsonata = string
      }))
    }), null)
    service_auth_401_redirect = optional(bool, false)
    session_duration          = string
    skip_interstitial         = optional(bool, null)
    tags                      = optional(list(string), [])
  }))
  default = {}
}

variable "access_policies" {
  description = "List of Access policies to manage"
  type = map(object({
    name     = string
    decision = string
    include = list(object({
      any_valid_service_token = optional(object({
        auth_method = string
      }), null)
      device_posture = optional(object({
        integration_uid = string
      }), null)
      everyone = optional(object({}), null)
      auth_context = optional(object({
        id                   = string
        ac_id                = string
        identity_provider_id = string
      }), null)
      auth_method = optional(object({
        auth_method = string
      }), null)
      group = optional(object({
        id = string
      }), null)
      gsuite = optional(object({
        email                = string
        identity_provider_id = string
      }), null)
      azure_ad = optional(object({
        id                   = string
        identity_provider_id = string
      }), null)
      common_name = optional(object({
        common_name = string
      }), null)
      email = optional(object({
        email = string
      }), null)
      email_domain = optional(object({
        domain = string
      }), null)
      email_list = optional(object({
        id = string
      }), null)
      ip_list = optional(object({
        id = string
      }), null)
      login_method = optional(object({
        id = string
      }), null)
      service_token = optional(object({
        token_id = string
      }), null)
      saml = optional(object({
        attribute_name       = string
        attribute_value      = string
        identity_provider_id = string
      }), null)
      github_organization = optional(object({
        team                 = string
        name                 = string
        identity_provider_id = string
      }), null)

    }))
    precedence = optional(number, 0)
    exclude = list(object({
      any_valid_service_token = optional(object({
        auth_method = string
      }), null)
      device_posture = optional(object({
        integration_uid = string
      }), null)
      everyone = optional(object({}), null)
      auth_context = optional(object({
        id                   = string
        ac_id                = string
        identity_provider_id = string
      }), null)
      auth_method = optional(object({
        auth_method = string
      }), null)
      group = optional(object({
        id = string
      }), null)
      gsuite = optional(object({
        email                = string
        identity_provider_id = string
      }), null)
      azure_ad = optional(object({
        id                   = string
        identity_provider_id = string
      }), null)
      common_name = optional(object({
        common_name = string
      }), null)
      email = optional(object({
        email = string
      }), null)
      email_domain = optional(object({
        domain = string
      }), null)
      email_list = optional(object({
        id = string
      }), null)
      ip_list = optional(object({
        id = string
      }), null)
      login_method = optional(object({
        id = string
      }), null)
      service_token = optional(object({
        token_id = string
      }), null)
      saml = optional(object({
        attribute_name       = string
        attribute_value      = string
        identity_provider_id = string
      }), null)
      github_organization = optional(object({
        team                 = string
        name                 = string
        identity_provider_id = string
      }), null)

    }))
    require = list(object({
      any_valid_service_token = optional(object({
        auth_method = string
      }))
      device_posture = optional(object({
        integration_uid = string
      }), null)
      everyone = optional(object({}), null)
      auth_context = optional(object({
        id                   = string
        ac_id                = string
        identity_provider_id = string
      }), null)
      auth_method = optional(object({
        auth_method = string
      }), null)
      group = optional(object({
        id = string
      }), null)
      gsuite = optional(object({
        email                = string
        identity_provider_id = string
      }), null)
      azure_ad = optional(object({
        id                   = string
        identity_provider_id = string
      }), null)
      common_name = optional(object({
        common_name = string
      }), null)
      email = optional(object({
        email = string
      }), null)
      email_domain = optional(object({
        domain = string
      }), null)
      email_list = optional(object({
        id = string
      }), null)
      ip_list = optional(object({
        id = string
      }), null)
      login_method = optional(object({
        id = string
      }), null)
      service_token = optional(object({
        token_id = string
      }), null)
      saml = optional(object({
        attribute_name       = string
        attribute_value      = string
        identity_provider_id = string
      }), null)
      github_organization = optional(object({
        team                 = string
        name                 = string
        identity_provider_id = string
      }), null)
    }))
    session_duration  = optional(string, null)
    approval_required = optional(bool, false)
    approval_groups = optional(list(object({
      approvals_needed = number
      email_addresses  = list(string)
      email_list_uuid  = string
    })), null)
    purpose_justification_prompt   = optional(string, null)
    purpose_justification_required = optional(bool, false)
    isolation_required             = optional(bool, false)
  }))
  default = {}
}

variable "access_groups" {
  description = "List of Access groups to manage"
  type = map(object({
    name = string
    include = object({
      email  = optional(list(string))
      emails = optional(list(string))
      group  = optional(list(string))
    })
  }))
  default = {}
}

variable "gateway_policies" {
  description = "List of Zero Trust Gateway policies"
  type = map(object({
    name           = string
    enabled        = optional(bool, true)
    action         = string
    filters        = list(string)
    traffic        = optional(string)
    identity       = optional(string)
    device_posture = optional(string)
  }))
  default = {}
}

variable "gateway_settings" {
  description = "List of Zero Trust Gateway settings"
  type = map(object({
    account_id                 = string
    antivirus_enabled_download = optional(bool, true)
    antivirus_enabled_upload   = optional(bool, true)
    antivirus_fail_closed      = optional(bool, true)
    tls_decrypt_enabled        = optional(bool, true)
  }))
  default = {}
}

variable "tunnels" {
  description = "List of Zero Trust tunnels"
  type = map(object({
    name       = string
    config_src = optional(string, "cloudflare")
    routes = optional(list(object({
      virtual_network = string
      network         = string
      comment         = string
    })), [])
    cloudflared_config = optional(object({
      ingress = list(object({
        hostname                 = optional(string)
        auto_create_dns_zone_key = optional(string, null)
        service                  = string
        origin_request = optional(object({
          access = optional(object({
            aud_tag   = optional(list(string))
            team_name = optional(string)
            required  = optional(bool, true)
          }))
          ca_pool                  = optional(string)
          connect_timeout          = optional(number)
          disable_chunked_encoding = optional(bool)
          http2_origin             = optional(bool, true)
          http_host_header         = optional(string)
          keep_alive_connections   = optional(number)
          keep_alive_timeout       = optional(number)
          no_happy_eyeballs        = optional(bool)
          no_tls_verify            = optional(bool)
          origin_server_name       = optional(string)
          proxy_type               = optional(string)
          tcp_keep_alive           = optional(number)
          tls_timeout              = optional(number)
        }))
        path = optional(string)
      }))
      origin_request = optional(object({
        access = optional(object({
          aud_tag   = optional(list(string))
          team_name = optional(string)
          required  = optional(bool)
        }))
        ca_pool                  = optional(string)
        connect_timeout          = optional(number)
        disable_chunked_encoding = optional(bool)
        http2_origin             = optional(bool)
        http_host_header         = optional(string)
        keep_alive_connections   = optional(number)
        keep_alive_timeout       = optional(number)
        no_happy_eyeballs        = optional(bool)
        no_tls_verify            = optional(bool)
        origin_server_name       = optional(string)
        proxy_type               = optional(string)
        tcp_keep_alive           = optional(number)
        tls_timeout              = optional(number)
      }))
      warp_routing = optional(object({
        enabled = bool
      }), { enabled = true })
    }), null)
  }))
  default = {}
}

variable "virtual_networks" {
  description = "List of Zero Trust virtual networks"
  type = map(object({
    is_default_network = optional(bool, false)
    is_default         = optional(bool, false)
    comment            = optional(string)
  }))
  default = {}
}

variable "lists" {
  description = "Zero Trust lists to create (e.g. IP, SERIAL, DOMAIN, URL, EMAIL)"
  type = map(object({
    name        = string                 # List name :contentReference[oaicite:1]{index=1}
    type        = string                 # One of IP, SERIAL, URL, DOMAIN, EMAIL :contentReference[oaicite:2]{index=2}
    description = optional(string)       # Optional list-level description :contentReference[oaicite:3]{index=3}
    items = list(object({
      value       = string               # Entry value (IP, serial, domain, etc.) :contentReference[oaicite:4]{index=4}
      description = optional(string)     # Optional per-item description :contentReference[oaicite:5]{index=5}
    }))
  }))
  default = []
}

variable "cloudflare_secrets" {
  description = "Provide a sensitive Map of secrets to be used in Cloudflare"
  type = object({
    tunnel_secrets = optional(map(object({
      secret = string
    })), {})
  })
  default = {
    tunnel_secrets = {}
  }
  sensitive = true
}

variable "zones" {
  description = "List of DNS zones to manage"
  type = map(object({
    name = string
    id   = string
  }))
}

variable "firewall_ruleset" {
  description = "Cloudflare Ruleset configuration"
  type = map(object({
    kind        = string
    name        = string
    phase       = string
    description = string
    zone_key    = string
    rules = list(object({
      action      = string
      description = string
      expression  = string
      enabled     = bool
      logging = optional(object({
        enabled = bool
      }), null)
      ratelimit = optional(object({
        characteristics     = list(string)
        mitigation_timeout  = number
        period              = number
        requests_per_period = number
        rate_exceeds        = string
      }), null)
      version = optional(string)
      position = optional(object({
        index = number
      }))
      customCounter = optional(bool, false)
    }))
  }))
}