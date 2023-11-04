output "ansible_inventory" {
  value = templatefile("${path.module}/templates/inventory.tftpl", {
    devops      = hcloud_server.server_devops.ipv4_address,
    k8s_servers = concat(tolist([hcloud_server.server_k8s_test.ipv4_address]), module.test_cluster.node_ipv6_addresses)
  })
}