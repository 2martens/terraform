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

// domain key
resource "inwx_nameserver_record" "twomartens_de_uberspace-domainkey_txt" {
  domain  = local.domain
  name    = "uberspace._domainkey.2martens.de"
  content = "v=DKIM1;t=s;n=core;p=MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA3inJYRQRdWD0NQf9WRVcct8Z+GF74WYCK9Q9E/hl9qRSrqHLbm4AZ8gDWZDUQ7O0WbsQ4wcBa2SLB0znpW2UmVrp0iMhqGXVU5USWTHLgAPOVo9DKKbY5wCuugftQe99hvW1Z5BNhzvGUczknQHW/oZF/a7l1nwkYuAZ9YyzQY+sB8o3euuZ0QxaVde0UNDMGpjUO/Nd8MRZj1WBNNyy12ppKVskg7GzuVpulkskslM/mAWdTJ7HKZh1HHPjjGS2ttyDMGWU7/sxuenZ5Z46PvKWQ37djwEsXqXuqYrLI+QBoefolhisHNhHA9cwuUU3bq/+zXhLTN4bYZVPeV31mM6cguKJibPXg0HgYUImJ0A/sADYcd4q7ryZ/sAzCydPT4FDrx64apRPlaIhugSU1KCz+N+7UtCjrQaJLA8i/F4+krfZpfiYr5MJrI8jTAZFW9lzGL7NTVLe1yDf/9aJGc7R/TyI/c5uGFGUnu0C+AKC5KJCIf/I2hJ9ARRRzKe1RtmiTJMAxi8FqzRQoEQwfSDi+vGXtrUC4JCV2Zh7xgwmZV+lMiP5M6x3aOM7FI26WPx+7tdRlzWiYu7okS5ayAgu26EYoKjGuWWHGUuKSKNqjTy3oBunZv3LzdnhOAn4eOrE7+2qn8hiL8SLa9oGcUv1BI0KQmopIAY+BiaX6JkCAwEAAQ=="
  type    = "TXT"
  ttl     = 3600
}