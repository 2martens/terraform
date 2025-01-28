data "keycloak_realm" "master" {
  realm = "master"
}

data "keycloak_openid_client" "master_realm_client" {
  realm_id  = data.keycloak_realm.master.id
  client_id = "master-realm"
}

data "keycloak_role" "query_clients" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "query-clients"
}

data "keycloak_role" "query_groups" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "query-groups"
}

data "keycloak_role" "query_realms" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "query-realms"
}

data "keycloak_role" "query_users" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "query-users"
}

data "keycloak_role" "view_authorization" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "view-authorization"
}

data "keycloak_role" "view_clients" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "view-clients"
}

data "keycloak_role" "view_events" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "view-events"
}

data "keycloak_role" "view_identity_providers" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "view-identity-providers"
}

data "keycloak_role" "view_realm" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "view-realm"
}

data "keycloak_role" "view_users" {
  realm_id   = data.keycloak_realm.master.id
  client_id  = data.keycloak_openid_client.master_realm_client.id
  name       = "view-users"
}

resource "keycloak_group" "admin_group" {
  realm_id   = data.keycloak_realm.master.id
  name       = "admin"
}

resource "keycloak_group_roles" "group_roles" {
  realm_id = data.keycloak_realm.master.id
  group_id = keycloak_group.admin_group.id

  role_ids = [
    data.keycloak_role.query_clients.id,
    data.keycloak_role.query_groups.id,
    data.keycloak_role.query_realms.id,
    data.keycloak_role.query_users.id,
    data.keycloak_role.view_authorization.id,
    data.keycloak_role.view_clients.id,
    data.keycloak_role.view_events.id,
    data.keycloak_role.view_identity_providers.id,
    data.keycloak_role.view_realm.id,
    data.keycloak_role.view_users.id,
  ]
}

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
