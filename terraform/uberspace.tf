// Identity management
module "keycloak_domain" {
  source      = "./modules/domain"
  domain      = "2martens.de"
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
  domain    = "2martens.de"
  subdomain = "wahlrecht"
  ipv4      = "185.26.156.43"
  ipv6      = "2a00:d0c0:200:0:470:9fff:fe83:16bc"
}

// CI/CD
module "gitea_domain" {
  source    = "./modules/domain"
  domain    = "2martens.de"
  subdomain = "git"
  ipv4      = "185.26.156.91"
  ipv6      = "2a00:d0c0:200:0:b9:1a:9c:5a"
}

module "helm-repo_domain" {
  source    = "./modules/domain"
  domain    = "2martens.de"
  subdomain = "repo"
  ipv4      = "185.26.156.49"
  ipv6      = "2a00:d0c0:200:0:2ca6:bff:fe78:832f"
}

// Monitoring
module "statping_domain" {
  source    = "./modules/domain"
  domain    = "2martens.de"
  subdomain = "status"
  ipv4      = "185.26.156.33"
  ipv6      = "2a00:d0c0:200:0:f8e2:6fff:fec2:7a92"
}

// Personal Website
module "personal_website_domain" {
  source      = "./modules/domain"
  domain      = "2martens.de"
  subdomain   = ""
  ipv4        = "185.26.156.65"
  ipv6        = "2a00:d0c0:200:0:b9:1a:9c:40"
  hasMXRecord = true
  hostName    = "howell.uberspace.de"
  mxPrio      = 10
  mxSpf       = "v=spf1 include:spf.uberspace.de"
}
resource "inwx_nameserver_record" "twomartens_de_google-verification_txt" {
  domain  = "2martens.de"
  name    = "2martens.de"
  content = "google-site-verification=nUFiHQFxBpBMdX96ELH3TcfyIfXf2ZlwMFYtXjVq5lo"
  type    = "TXT"
  ttl     = 3600
}

// Nextcloud
module "nextcloud_domain" {
  source      = "./modules/domain"
  domain      = "2martens.de"
  subdomain   = "cloud"
  ipv4        = "185.26.156.194"
  ipv6        = "2a00:d0c0:200:0:b9:1a:9c:95"
  hasMXRecord = true
  hostName    = "kushida.uberspace.de"
  mxPrio      = 0
  mxSpf       = "v=spf1 mx ~all"
}

// domain key
resource "inwx_nameserver_record" "twomartens_de_uberspace-domainkey_txt" {
  domain  = "2martens.de"
  name    = "uberspace._domainkey.id.2martens.de"
  content = "v=DKIM1;t=s;n=core;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqs3bFL8W77z7VJHCFbsJ3o68Y1uBbVsbIS1y35CMfRv6wp7si7aIG2ZeKqzdh2dTMsvtvSMaYVq1gT/EtRmTbU/BYC21ff8sqcVqn/ll5nNsk5jKWXTYAlTQp4LBQN7icw94ZNGr5/SDYcnv2nsBYFf2GUviObWXGHX4RaBFNj9NVUNWNin/HicvW+LsbfYq37QtlhjmUn9K96VCwKcTV1mx+Ek0osErYefcOVNawqWIlVRQDLkHZhk1StLsOpRqV+qEjhzTk4n4ZiNtLJG1D9CpHl24d5DKsQDyVFdEfqHimFTSNgiitlkuXg+i+NMiRA9G3gNJtvw8uvfN8f+stQIDAQAB"
  type    = "TXT"
  ttl     = 3600
}