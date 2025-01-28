resource "keycloak_realm" "twomartens_realm" {
  realm   = "twomartens"
  enabled = true

  display_name = "2martens Applications"
  display_name_html = "<div class=\"kc-logo-text\"><span>2martens</span></div>"

  login_theme = "keycloak.v2"
  account_theme = "keycloak.v3"
  admin_theme = "keycloak.v2"
  email_theme = "keycloak"

  # Security settings
  password_policy = "upperCase(1) and length(12) and forceExpiredPasswordChange(365) and notUsername"

  # Brute force protection
  security_defenses {
    brute_force_detection {
      max_login_failures = 5
    }
  }
}
