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

  default_signature_algorithm = "ES256"
  revoke_refresh_token        = true
  refresh_token_max_reuse     = 0

  web_authn_policy {
    signature_algorithms              = ["ES256"]
    avoid_same_authenticator_register = true
  }

  web_authn_passwordless_policy {
    signature_algorithms              = ["ES256"]
    avoid_same_authenticator_register = true
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

resource "keycloak_openid_client" "twomartens_gitea" {
  realm_id              = keycloak_realm.twomartens_realm.id
  name                  = "Gitea"
  enabled               = true
  access_type           = "CONFIDENTIAL"
  client_id             = "gitea"
  client_secret         = var.gitea_client_secret
  standard_flow_enabled = true
  use_refresh_tokens    = false


  consent_required = true
  base_url         = "https://git.2martens.de"
  valid_redirect_uris = [
    "https://git.2martens.de/user/oauth2/keycloak/callback"
  ]
}

resource "keycloak_openid_client" "twomartens_nextcloud" {
  realm_id              = keycloak_realm.twomartens_realm.id
  name                  = "cloud.2martens.de"
  enabled               = true
  access_type           = "CONFIDENTIAL"
  client_id             = "nextcloud"
  client_secret         = var.nextcloud_client_secret
  standard_flow_enabled = true
  use_refresh_tokens    = true


  consent_required = true
  base_url         = "https://cloud.2martens.de"
  valid_redirect_uris = [
    "https://cloud.2martens.de/index.php/apps/sociallogin/custom_oidc/keycloak"
  ]
  valid_post_logout_redirect_uris = [
    "https://cloud.2martens.de"
  ]
  web_origins = [
    "https://cloud.2martens.de/*"
  ]
}
