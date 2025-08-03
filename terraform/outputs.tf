# output "ansible_inventory" {
#   value = templatefile("${path.module}/templates/inventory.tftpl", {
#     devops = hcloud_server.server_devops.ipv4_address,
#     k8s_servers = concat(
#       module.test_cluster.node_ipv6_addresses
#     )
#   })
# }

output "swarm_nodes" {
  value = module.test_swarm_cluster.node_details
}

output "swarm_worker_nodes" {
  value = module.test_swarm_cluster.worker_node_details
}

output "swarm_loadbalancer" {
  value = module.test_swarm_cluster.loadbalancer_details
}