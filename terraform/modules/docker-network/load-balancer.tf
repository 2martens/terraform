resource "hcloud_load_balancer" "docker" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_type = var.loadbalancer_type
  name = format("%s_%s", "docker", var.stage_name)
  location           = element(var.locations.*.name, count.index)
  network_zone       = element(var.locations.*.network_zone, count.index)
  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_network" "private" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.docker[count.index].id
  subnet_id        = var.server_subnet_id
  ip               = var.loadbalancer_ip
}

resource "hcloud_load_balancer_target" "nodes" {
  count = var.number_nodes > 1 ? var.number_nodes : 0

  type             = "server"
  load_balancer_id = hcloud_load_balancer.docker[0].id
  server_id        = hcloud_server.node[count.index].id
  use_private_ip   = true
}

resource "hcloud_load_balancer_service" "http" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.docker[count.index].id
  protocol         = "http"
  listen_port      = 80
  destination_port = 80

  http {
    sticky_sessions = true
    cookie_name     = "selected_node_for_session"
  }
}

resource "hcloud_load_balancer_service" "https" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.docker[count.index].id
  protocol         = "https"
  listen_port      = 443
  destination_port = 443

  http {
    sticky_sessions = true
    cookie_name     = "selected_node_for_session"
  }
}