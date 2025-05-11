output "access_applications_aud_tags" {
  value = {
    for app_key, app in cloudflare_zero_trust_access_application.this : app_key => app.aud
  }
}
