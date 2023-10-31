output "ansible_inventory" {
  value = templatefile("${path.module}/inventory.tftpl", {
    devops = hcloud_server.server_devops.ipv4_address, k8s_servers = [hcloud_server.server_k8s_test.ipv4_address]
  })
}