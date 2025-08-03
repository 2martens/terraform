// Identity management
module "keycloak_domain" {
  source      = "./modules/domain"
  domain      = local.domain
  subdomain   = "id"
  ipv4        = "95.143.172.184"
  ipv6        = "2001:1a50:11:0:98b3:92ff:fe3e:bba1"
  hasMXRecord = true
  hostName    = "monoceres.uberspace.de"
  mxPrio      = 0
  mxSpf       = "v=spf1 include:spf.uberspace.de ~all"
}

// Angular frontends
module "wahlrecht_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "wahlrecht"
  ipv4      = "185.26.156.43"
  ipv6      = "2a00:d0c0:200:0:470:9fff:fe83:16bc"
}

// CI/CD
module "gitea_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "git"
  ipv4      = "185.26.156.91"
  ipv6      = "2a00:d0c0:200:0:b9:1a:9c:5a"
}

module "helm-repo_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "repo"
  ipv4      = "185.26.156.49"
  ipv6      = "2a00:d0c0:200:0:2ca6:bff:fe78:832f"
}

// Monitoring
module "statping_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "status"
  ipv4      = "185.26.156.33"
  ipv6      = "2a00:d0c0:200:0:f8e2:6fff:fec2:7a92"
}

// Personal Website
module "personal_website_domain" {
  source      = "./modules/domain"
  domain      = local.domain
  subdomain   = ""
  ipv4        = "185.26.156.65"
  ipv6        = "2a00:d0c0:200:0:b9:1a:9c:40"
  hasMXRecord = true
  hostName    = "howell.uberspace.de"
  mxPrio      = 0
  mxSpf       = "v=spf1 include:spf.uberspace.de ~all"
}
resource "inwx_nameserver_record" "twomartens_de_google-verification_txt" {
  domain  = local.domain
  name    = local.domain
  content = "google-site-verification=nUFiHQFxBpBMdX96ELH3TcfyIfXf2ZlwMFYtXjVq5lo"
  type    = "TXT"
  ttl     = 3600
}

// Nextcloud
module "nextcloud_domain" {
  source      = "./modules/domain"
  domain      = local.domain
  subdomain   = "cloud"
  ipv4        = "185.26.156.194"
  ipv6        = "2a00:d0c0:200:0:b9:1a:9c:95"
  hasMXRecord = true
  hostName    = "kushida.uberspace.de"
  mxPrio      = 0
  mxSpf       = "v=spf1 include:spf.uberspace.de ~all"
}