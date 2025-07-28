data "hcloud_placement_group" "default" {
  name = "default"
}

locals {
  docker_network_domain = format("%s.%s.%s", "docker", var.stage_name, var.domain)
}

# TODO: use Hetzner DNS
# resource "inwx_nameserver_record" "kube_api_server_a" {
#   domain  = var.domain
#   name    = local.docker_network_domain
#   content = hcloud_server.nginx.ipv4_address
#   type    = "A"
#   ttl     = 3600
# }
# resource "inwx_nameserver_record" "kube_api_server_aaaa" {
#   domain  = var.domain
#   name    = local.docker_network_domain
#   content = hcloud_server.nginx.ipv6_address
#   type    = "AAAA"
#   ttl     = 3600
# }