provider "inwx" {
  api_url  = "https://api.domrobot.com/jsonrpc/"
  username = var.inwx_user
  password = var.inwx_password
}

provider "hcloud" {
  token = var.hcloud_token
}