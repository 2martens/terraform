module "argocd_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "argocd"
  ipv4      = "49.13.77.70"
  ipv6      = "2a01:4f8:c012:4d25::1"
}

module "api_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "api"
  ipv4      = "49.13.77.70"
  ipv6      = "2a01:4f8:c012:4d25::1"
}

module "prometheus_k8s_test_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "prometheus.k8s.test"
  ipv4      = "49.13.77.70"
  ipv6      = "2a01:4f8:c012:4d25::1"
}