resource "hcloud_load_balancer" "docker" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_type = var.loadbalancer_type
  name = format("%s_%s", "docker", var.stage_name)
  location = element(var.locations.*.name, count.index)
  algorithm {
    type = "round_robin"
  }

  labels = {
    "docker" : "yes",
    "swarm" : "yes",
    "loadbalancer" : "yes"
  }
}

resource "hcloud_rdns" "ipv4_load_balancer" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.docker[count.index].id
  ip_address       = hcloud_load_balancer.docker[count.index].ipv4
  dns_ptr          = local.docker_network_domain
}

resource "hcloud_rdns" "ipv6_load_balancer" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.docker[count.index].id
  ip_address       = hcloud_load_balancer.docker[count.index].ipv6
  dns_ptr          = local.docker_network_domain
}

resource "hcloud_load_balancer_target" "nodes" {
  count = var.number_nodes > 1 ? var.number_nodes : 0

  type             = "server"
  load_balancer_id = hcloud_load_balancer.docker[0].id
  server_id        = hcloud_server.node[count.index].id
  use_private_ip   = false
}

resource "hcloud_load_balancer_service" "http" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.docker[count.index].id
  protocol         = "tcp"
  listen_port      = 80
  destination_port = 80
}

resource "hcloud_load_balancer_service" "https" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.docker[count.index].id
  protocol         = "tcp"
  listen_port      = 443
  destination_port = 443
}