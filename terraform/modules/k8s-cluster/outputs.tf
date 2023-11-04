output "api_server_ipv4_address" {
  value = var.create_loadbalancer ? hcloud_load_balancer.kubernetes.ipv4 : hcloud_server.manager[0].ipv4_address
}

output "api_server_ipv6_address" {
  value = var.create_loadbalancer ? hcloud_load_balancer.kubernetes.ipv6 : hcloud_server.manager[0].ipv6_address
}