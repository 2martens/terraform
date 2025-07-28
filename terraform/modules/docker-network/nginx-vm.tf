# TODO: Use Hetzner DNS
# resource "inwx_nameserver_record" "manager_aaaa" {
#   domain  = var.domain
#   name = format("%s.%s", "nginx", local.docker_network_domain)
#   content = hcloud_server.nginx.ipv6_address
#   type    = "AAAA"
#   ttl     = 3600
# }

resource "hcloud_primary_ip" "ipv4_nginx_address" {
  name = format("%s_%s_%s", "docker", var.stage_name, "ipv4")
  datacenter = element(var.locations.*.datacenter_name, 0)
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_rdns" "ipv4_nginx" {
  primary_ip_id = hcloud_primary_ip.ipv4_nginx_address.id
  ip_address    = hcloud_primary_ip.ipv4_nginx_address.ip_address
  # TODO: use Hetzner DNS
  # dns_ptr       = inwx_nameserver_record.manager_aaaa.name
}

resource "hcloud_primary_ip" "ipv6_nginx_address" {
  name = format("%s_%s_%s", "k8s", var.stage_name, "ipv6")
  datacenter = element(var.locations.*.datacenter_name, 0)
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_rdns" "ipv6_nginx" {
  primary_ip_id = hcloud_primary_ip.ipv6_nginx_address.id
  ip_address    = hcloud_server.nginx.ipv6_address
  # TODO: use Hetzner DNS
  # dns_ptr       = inwx_nameserver_record.manager_aaaa.name
}

resource "hcloud_server_network" "nginx_private" {
  server_id = hcloud_server.nginx.id
  subnet_id = var.server_subnet_id
  ip        = var.private_nginx_vm_ip
}

resource "hcloud_server" "nginx" {
  name = format("%s-%s-%s", "docker", var.stage_name, "nginx")
  image                   = var.image_name
  allow_deprecated_images = false
  server_type             = var.server_type
  location = element(var.locations.*.name, 0)

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.ipv4_nginx_address.id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.ipv6_nginx_address.id
  }

  ignore_remote_firewall_ids = false
  keep_disk                  = false
  placement_group_id         = data.hcloud_placement_group.default.id
  firewall_ids = [var.basic_firewall_id, var.docker_firewall_id]
  ssh_keys = [var.admin_ssh_key.id]
  shutdown_before_deletion   = true

  labels = {
    "docker" : "yes",
    "nginx" : "yes"
  }

  user_data = templatefile("${path.module}/templates/cloud-init-docker-with-nginx.yaml.tftpl", {
    admin_public_ssh_key : format("%s %s", var.admin_ssh_key.public_key, var.admin_ssh_key.name)
    admin_user : var.admin_user
    terraform_public_ssh_key : var.terraform_public_ssh_key
    packages_setup : base64encode(file("${path.module}/templates/scripts/install-packages.sh"))
    firewall_setup : base64encode(templatefile("${path.module}/templates/scripts/firewall-setup.sh", {
      node_ip : var.private_nginx_vm_ip
    }))
    ssh_setup : base64encode(templatefile("${path.module}/templates/scripts/ssh-setup.sh", {
      admin_user : var.admin_user
    }))
    sysctl_setup : base64encode(file("${path.module}/templates/scripts/sysctl-setup.sh"))
    nginx_setup : base64encode(file("${path.module}/templates/scripts/nginx-setup.sh"))
  })

  network {
    network_id = var.network_id
    ip         = var.private_nginx_vm_ip
    alias_ips = []
  }

  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
}