data "hcloud_placement_group" "default" {
  name = "default"
}

locals {
  kube_api_server_domain = format("%s.%s.%s", "k8s", var.cluster_name, var.domain)
}

resource "hcloud_load_balancer" "kubernetes" {
  count = var.create_loadbalancer ? 1 : 0

  load_balancer_type = var.loadbalancer_type
  name               = format("%s_%s", "k8s", var.cluster_name)
  location           = var.locations[count.index].name
  network_zone       = var.locations[count.index].network_zone
  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_network" "private" {
  count = var.create_loadbalancer ? 1 : 0

  load_balancer_id = hcloud_load_balancer.kubernetes[count.index].id
  subnet_id        = var.server_subnet_id
  ip               = var.loadbalancer_ip
}

resource "hcloud_load_balancer_target" "nodes" {
  count = var.create_loadbalancer ? var.number_nodes : 0

  type             = "server"
  load_balancer_id = hcloud_load_balancer.kubernetes[0].id
  server_id        = hcloud_server.manager[count.index].id
  use_private_ip   = true
}

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