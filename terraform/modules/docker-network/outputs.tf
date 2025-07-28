output "nginx_server_ipv4_address" {
  value = hcloud_server.nginx.ipv4_address
}

output "nginx_server_ipv6_address" {
  value = hcloud_server.nginx.ipv6_address
}
