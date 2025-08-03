data "hcloud_placement_group" "default" {
  name = "default"
}

locals {
  docker_network_domain = format("%s.%s.%s", "docker", var.stage_name, var.domain)
}
