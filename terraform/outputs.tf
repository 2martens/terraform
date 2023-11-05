output "ansible_inventory" {
  value = templatefile("${path.module}/templates/inventory.tftpl", {
    devops = hcloud_server.server_devops.ipv4_address,
    k8s_servers = concat(
      module.test_cluster.node_ipv6_addresses
    )
  })
}