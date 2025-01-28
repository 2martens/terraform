data "keycloak_realm" "master" {
  realm = "master"
}

data "keycloak_openid_client" "master_realm_client" {
  realm_id  = data.keycloak_realm.master.id
  client_id = "master-realm"
}

resource "keycloak_realm" "twomartens_realm" {
  realm   = "twomartens"
  enabled = true

  display_name      = "2martens Applications"
  display_name_html = "<div class=\"kc-logo-text\"><span>2martens</span></div>"

  login_theme   = "keycloak.v2"
  account_theme = "keycloak.v3"
  admin_theme   = "keycloak.v2"
  email_theme   = "keycloak"

  # Security settings
  password_policy = "upperCase(1) and length(12) and forceExpiredPasswordChange(365) and notUsername"

  # Brute force protection
  security_defenses {
    brute_force_detection {
      max_login_failures = 5
    }
  }
}

resource "keycloak_oidc_identity_provider" "twomartens_github_identity_provider" {
  realm        = keycloak_realm.twomartens_realm.id
  alias        = "github"
  display_name = "GitHub"
  provider_id  = "github"

  # OAuth App Configuration
  client_id     = var.github_identity_provider_client_id
  client_secret = var.github_identity_provider_client_secret

  # OAuth Endpoints
  authorization_url = "https://github.com/login/oauth/authorize"
  token_url         = "https://github.com/login/oauth/access_token"

  # Detailed User Mapping
  extra_config = {
    "clientAuthMethod" = "client_secret_post"
  }

  # Scopes and Sync Settings
  sync_mode = "IMPORT"

  # Logout and UI Settings
  ui_locales = true
}
