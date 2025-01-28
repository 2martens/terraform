provider "inwx" {
  api_url  = "https://api.domrobot.com/jsonrpc/"
  username = var.inwx_user
  password = var.inwx_password
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "keycloak" {
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
  url           = var.keycloak_url
}

provider "keycloak-legacy" {
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
  url           = var.keycloak_url
}