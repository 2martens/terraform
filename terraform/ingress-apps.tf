module "argocd_domain" {
  source    = "./modules/domain"
  domain    = "2martens.de"
  subdomain = "argocd"
  ipv4      = "49.13.77.70"
  ipv6      = "2a01:4f8:c012:4d25::1"
}

module "api_domain" {
  source    = "./modules/domain"
  domain    = "2martens.de"
  subdomain = "api"
  ipv4      = "49.13.77.70"
  ipv6      = "2a01:4f8:c012:4d25::1"
}