resource "inwx_nameserver_record" "kube_api_server_a" {
  domain  = var.domain
  name    = local.kube_api_server_domain
  content = var.create_loadbalancer ? hcloud_load_balancer.kubernetes[0].ipv4 : hcloud_primary_ip.ipv4_manager_address[0].ip_address
  type    = "A"
  ttl     = 3600
}
resource "inwx_nameserver_record" "kube_api_server_aaaa" {
  domain  = var.domain
  name    = local.kube_api_server_domain
  content = var.create_loadbalancer ? hcloud_load_balancer.kubernetes[0].ipv6 : hcloud_primary_ip.ipv6_manager_address[0].ip_address
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "argocd_a" {
  domain  = var.domain
  name    = format("%s.%s", "argocd", local.kube_api_server_domain)
  content = var.create_loadbalancer ? hcloud_load_balancer.kubernetes[0].ipv4 : hcloud_primary_ip.ipv4_manager_address[0].ip_address
  type    = "A"
  ttl     = 3600
}
resource "inwx_nameserver_record" "argocd_aaaa" {
  domain  = var.domain
  name    = format("%s.%s", "argocd", local.kube_api_server_domain)
  content = var.create_loadbalancer ? hcloud_load_balancer.kubernetes[0].ipv6 : hcloud_primary_ip.ipv6_manager_address[0].ip_address
  type    = "AAAA"
  ttl     = 3600
}