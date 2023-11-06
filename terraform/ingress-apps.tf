module "api_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "api"
  ipv4      = module.test_cluster.api_server_ipv4_address
  ipv6      = module.test_cluster.api_server_ipv6_address
}

module "prometheus_k8s_test_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "prometheus.k8s.test"
  ipv4      = module.test_cluster.api_server_ipv4_address
  ipv6      = module.test_cluster.api_server_ipv6_address
}

module "prometheus_k8s_test_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "thanos.prometheus.k8s.test"
  ipv4      = module.test_cluster.api_server_ipv4_address
  ipv6      = module.test_cluster.api_server_ipv6_address
}