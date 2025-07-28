# TODO: Use Hetzner DNS
# resource "inwx_nameserver_record" "worker_aaaa" {
#   count = var.number_worker_vms
#
#   domain  = var.domain
#   name    = format("%s-%d.%s", "node", count.index, local.docker_network_domain)
#   content = hcloud_server.worker[count.index].ipv6_address
#   type    = "AAAA"
#   ttl     = 3600
# }

resource "hcloud_primary_ip" "ipv6_worker_address" {
  count = var.number_worker_vms

  name          = format("%s_%s_%s_%d", "docker", var.stage_name, "ipv6", count.index)
  datacenter    = element(var.locations.*.datacenter_name, count.index)
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_rdns" "ipv6_worker" {
  count = var.number_worker_vms

  primary_ip_id = hcloud_primary_ip.ipv6_worker_address[count.index].id
  ip_address    = hcloud_server.worker[count.index].ipv6_address
  # TODO: Use Hetzner DNS
  # dns_ptr       = inwx_nameserver_record.worker_aaaa[count.index].name
}

resource "hcloud_server_network" "worker_private" {
  count = var.number_worker_vms

  server_id = hcloud_server.worker[count.index].id
  subnet_id = var.server_subnet_id
  ip        = var.private_worker_vm_ips[count.index]
}

resource "hcloud_server" "worker" {
  count = var.number_worker_vms

  name                    = format("%s-%s-%s-%d", "docker", var.stage_name, "node", count.index)
  image                   = var.image_name
  allow_deprecated_images = false
  server_type             = var.server_type
  location                = element(var.locations.*.name, count.index)
  public_net {
    ipv4_enabled = false
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.ipv6_worker_address[count.index].id
  }
  ignore_remote_firewall_ids = false
  keep_disk                  = false
  placement_group_id         = data.hcloud_placement_group.default.id
  firewall_ids               = [var.basic_firewall_id, var.docker_firewall_id]
  ssh_keys                   = [var.admin_ssh_key.id]
  shutdown_before_deletion   = true

  labels = {
    "docker" : "yes"
  }

  user_data = templatefile("${path.module}/templates/cloud-init-docker-no-nginx.yaml.tftpl", {
    admin_public_ssh_key : format("%s %s", var.admin_ssh_key.public_key, var.admin_ssh_key.name)
    admin_user : var.admin_user
    terraform_public_ssh_key : var.terraform_public_ssh_key
    packages_setup : base64encode(file("${path.module}/templates/scripts/install-packages.sh"))
    firewall_setup : base64encode(templatefile("${path.module}/templates/scripts/firewall-setup.sh", {
      node_ip : var.private_worker_vm_ips[count.index]
    }))
    ssh_setup : base64encode(templatefile("${path.module}/templates/scripts/ssh-setup.sh", {
      admin_user : var.admin_user
    }))
    sysctl_setup : base64encode(file("${path.module}/templates/scripts/sysctl-setup.sh"))
  })

  network {
    network_id = var.network_id
    ip         = var.private_worker_vm_ips[count.index]
    alias_ips  = []
  }

  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
}