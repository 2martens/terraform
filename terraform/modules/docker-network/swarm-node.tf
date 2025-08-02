resource "hcloud_primary_ip" "ipv4_node_address" {
  count = var.number_nodes

  name = format("%s_%s_%s_%d", "docker", var.stage_name, "ipv4", count.index)
  datacenter    = var.locations[count.index].datacenter_name
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_rdns" "ipv4_node" {
  count = var.number_nodes

  primary_ip_id = hcloud_primary_ip.ipv4_node_address[count.index].id
  ip_address    = hcloud_primary_ip.ipv4_node_address[count.index].ip_address
  dns_ptr = format("%s-%d.%s", "node", count.index, local.docker_network_domain)
}

resource "hcloud_primary_ip" "ipv6_node_address" {
  count = var.number_nodes

  name = format("%s_%s_%s_%d", "docker", var.stage_name, "ipv6", count.index)
  datacenter    = var.locations[count.index].datacenter_name
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_rdns" "ipv6_node" {
  count = var.number_nodes

  primary_ip_id = hcloud_primary_ip.ipv6_node_address[count.index].id
  ip_address    = hcloud_server.node[count.index].ipv6_address
  dns_ptr = format("%s-%d.%s", "node", count.index, local.docker_network_domain)
}

resource "hcloud_server_network" "nginx_private" {
  count = var.number_nodes

  server_id = hcloud_server.node[count.index].id
  subnet_id = var.server_subnet_id
  ip        = var.private_node_ips[count.index]
}

resource "hcloud_server" "node" {
  count = var.number_nodes

  name = format("%s-%s-%s-%d", "docker", var.stage_name, "node", count.index)
  image                   = var.image_name
  allow_deprecated_images = false
  server_type             = var.server_type
  location                = var.locations[count.index].name

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.ipv4_node_address[count.index].id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.ipv6_node_address[count.index].id
  }

  ignore_remote_firewall_ids = false
  keep_disk                  = false
  placement_group_id         = data.hcloud_placement_group.default.id
  firewall_ids = [var.basic_firewall_id]
  ssh_keys = [var.admin_ssh_key.id]
  shutdown_before_deletion   = true

  labels = {
    "docker" : "yes",
    "swarm" : "yes"
  }

  user_data = templatefile("${path.module}/templates/cloud-init-docker.yaml.tftpl", {
    admin_public_ssh_key : format("%s %s", var.admin_ssh_key.public_key, var.admin_ssh_key.name)
    admin_user : var.admin_user
    terraform_public_ssh_key : var.terraform_public_ssh_key
    github_public_ssh_key : var.github_public_ssh_key
    main_node : count.index == 0
    packages_setup : base64encode(file("${path.module}/templates/scripts/install-packages.sh"))
    firewall_setup : base64encode(templatefile("${path.module}/templates/scripts/firewall-setup.sh.tftpl", {
      node_ip : var.private_node_ips[count.index]
      main_node : count.index == 0
    }))
    ssh_setup : base64encode(templatefile("${path.module}/templates/scripts/ssh-setup.sh.tftpl", {
      admin_user : var.admin_user
    }))
    sysctl_setup : base64encode(file("${path.module}/templates/scripts/sysctl-setup.sh"))
    swarm_setup : base64encode(templatefile("${path.module}/templates/scripts/swarm-setup.sh.tftpl", {
      main_node : count.index == 0
      main_node_private_ip : var.private_node_ips[0]
    }))
  })

  network {
    network_id = var.network_id
    ip         = var.private_node_ips[count.index]
    alias_ips = []
  }

  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
}
