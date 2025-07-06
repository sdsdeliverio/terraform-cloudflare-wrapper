variable "cloudflare_api_token" {
  description = "The API token for Cloudflare authentication"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "The Cloudflare account ID"
  type        = string
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "production"
}

variable "zones" {
  description = "Zones to manage"
  type = map(object({
    id                   = string
    name                 = string
    paused               = optional(bool, false)
    plan                 = optional(string, "free")
    type                 = optional(string, "full")
    dns_settings_enabled = optional(bool, true)
    enable_dnssec        = optional(bool, true)
  }))
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Module enablement flags
variable "enabled_modules" {
  description = "Map of modules to enable/disable"
  type        = map(bool)
  default = {
    account_authentication  = true
    dns_networking          = true
    email_management        = true
    security_bot_management = true
    ssl_tls_certificates    = true
    workers                 = true
    zero_trust_security     = true
    pages_delivery          = true
    r2_storage              = true
  }
}

variable "dns_networking_config" {
  description = "List of zones and their DNS records configurations"
  type = object({
    records = optional(list(object({
      zone_key = string
      records = list(object({
        name     = string
        type     = string
        content  = string
        ttl      = number
        proxied  = optional(bool, false)
        priority = optional(number)
        comment  = optional(string, "Managed by Terraform")
      }))
    })), [])
  })
  default = {
    records = []
  }
}

variable "email_management_config" {
  description = "Configuration for the email management module"
  type = object({
    catch_all_rule = optional(object({
      catchall_email = optional(string)
      zone_key       = optional(string)
    }))
    aliasroute2email = optional(list(object({
      alias          = optional(string)
      action         = optional(string, "forward")
      email_to_route = optional(string)
      zone_key       = optional(string)
    })), [])
  })
  default = {
    aliasroute2email = []
    catch_all_rule = {
      action = "drop"
    }
  }
}

variable "cloudflare_bot_management" {
  description = "Bot management configuration"
  type = object({
    ai_bots_protection = optional(string, "block")
    fight_mode         = optional(bool, true)
    enable_js          = optional(bool, true)
  })
  default = {
    ai_bots_protection = "block"
    fight_mode         = true
    enable_js          = true
  }
}

# Security Bot Management Module Variables
variable "security_bot_config" {
  description = "Configuration for the security and bot management module"
  type        = any
  default     = {}
}

# SSL/TLS Certificates Module Variables
variable "ssl_tls_config" {
  description = "Configuration for the SSL/TLS certificates module"
  type        = any
  default     = {}
}

# Workers Module Variables
variable "workers_config" {
  description = "Configuration for the Workers module"
  type        = any
  default     = {}
}

variable "cloudflare_secrets" {
  description = "Provide a sensitive Map of secrets to be used in Cloudflare"
  type = object({
    tunnel_secrets = optional(map(object({
      secret = string
    })), {})
    api_keys = optional(map(object({
      secret = string
    })), {})
    service_tokens = optional(map(object({
      secret = string
    })), {})
  })
  default   = {}
  sensitive = true
}

# Zero Trust Security Module Variables
variable "zero_trust_config" {
  description = "Configuration for the Zero Trust security module"
  type = object({
    tunnels = optional(map(object({
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
          service                  = string
          auto_create_dns_zone_key = optional(string)
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
        }), null)
        warp_routing = optional(object({
          enabled = bool
        }), { enabled = true })
      }))
    })), {})
    lists = optional(map(object({
      name        = string
      type        = string
      description = optional(string, "Managed by Terraform")
      items = list(object({
        value   = string
        comment = optional(string, "")
      }))
    })), {})
    virtual_networks = optional(map(object({
      is_default_network = optional(bool, false)
      is_default         = optional(bool, false)
      comment            = optional(string)
    })), {})
    gateway_policies = optional(map(object({
      name           = string
      enabled        = optional(bool, true)
      action         = string
      filters        = list(string)
      traffic        = optional(string)
      identity       = optional(string)
      device_posture = optional(string)
    })), {})
    gateway_settings = optional(map(object({
      account_id                 = string
      antivirus_enabled_download = optional(bool, true)
      antivirus_enabled_upload   = optional(bool, true)
      antivirus_fail_closed      = optional(bool, true)
      tls_decrypt_enabled        = optional(bool, true)
    })), {})
    access_applications = optional(map(object({
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
      tags                      = optional(list(string), null)
    })), {})
    access_policies = optional(map(object({
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
      exclude = optional(list(object({
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

      })), [])
      require = optional(list(object({
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
      })), [])
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
    })))
    firewall_ruleset = optional(map(object({
      kind        = string
      name        = string
      phase       = string
      zone_key    = string
      description = string
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
      }))
    })))
  })
  default = {
    tunnels             = {}
    virtual_networks    = {}
    gateway_policies    = {}
    gateway_settings    = {}
    access_applications = {}
    access_policies     = {}
    firewall_ruleset    = {}
  }
}

# Pages Delivery Module Variables
variable "pages_delivery_config" {
  description = "Configuration for the Pages delivery module"
  type        = any
  default     = {}
}

# R2 Storage Module Variables
variable "r2_storage_config" {
  description = "Configuration for the R2 storage module"
  type        = any
  default     = {}
}
