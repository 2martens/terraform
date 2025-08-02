output "node_details" {
  value = {
    for idx, instance in hcloud_server.node :
    "node-${idx}" => {
      id      = instance.id
      name    = instance.name
      ipv4    = instance.ipv4_address
      ipv6    = instance.ipv6_address
    }
  }
}