data "hcloud_placement_group" "default" {
  name = "default"
}

locals {
  docker_network_domain = format("%s.%s.%s", "docker", var.stage_name, var.domain)
}

resource "hcloud_load_balancer" "docker" {
  count = var.number_nodes > 1 ? 1 : 0

  load_balancer_type = var.loadbalancer_type
  name               = format("%s_%s", "docker", var.stage_name)
  location           = var.locations[count.index].name
  network_zone       = var.locations[count.index].network_zone
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
