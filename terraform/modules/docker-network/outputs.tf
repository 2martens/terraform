output "node_details" {
  value = {
    for idx, instance in hcloud_server.node :
    "node-${idx}" => {
      id   = instance.id
      name = instance.name
      ipv4 = instance.ipv4_address
      ipv6 = instance.ipv6_address
    }
  }
}

output "worker_node_details" {
  value = {
    for idx, instance in hcloud_server.worker_node :
    "worker-node-${idx}" => {
      id   = instance.id
      name = instance.name
      ipv4 = instance.ipv4_address
      ipv6 = instance.ipv6_address
    }
  }
}

output "loadbalancer_details" {
  value = {
    for idx, instance in hcloud_load_balancer.docker :
    "loadbalancer-${idx}" => {
      ipv4 = instance.ipv4
      ipv6 = instance.ipv6
    }
  }
}
