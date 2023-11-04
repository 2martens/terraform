resource "inwx_nameserver_record" "worker_aaaa" {
  count = var.number_worker_nodes

  domain  = var.domain
  name    = format("%s-%d.%s", "node", count.index, local.kube_api_server_domain)
  content = hcloud_primary_ip.ipv6_worker_address[count.index].ip_address
  type    = "AAAA"
  ttl     = 3600
}

resource "hcloud_primary_ip" "ipv6_worker_address" {
  count = var.number_worker_nodes

  name          = format("%s_%s_%s_%d", "k8s", var.cluster_name, "ipv6", count.index)
  datacenter    = element(var.locations.*.datacenter_name, count.index)
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server_network" "worker_private" {
  count = var.number_worker_nodes

  server_id = hcloud_server.worker[count.index].id
  subnet_id = var.server_subnet_id
  ip        = var.private_worker_node_ips[count.index]
}

resource "hcloud_server" "worker" {
  count = var.number_worker_nodes

  name                    = format("%s_%s_%s_%d", "k8s", var.cluster_name, "node", count.index)
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
  labels = {
    "kubernetes" : "yes",
    "worker" : "yes"
  }
  firewall_ids = [var.basic_firewall_id, var.k8s_firewall_id]
  ssh_keys     = [var.admin_ssh_key.id]
  user_data = templatefile("${path.module}/templates/cloud-init-k8s.tftpl", {
    node_ip : var.private_worker_node_ips[count.index],
    admin_public_ssh_key : format("%s %s", var.admin_ssh_key.public_key, var.admin_ssh_key.name),
    terraform_public_ssh_key : var.terraform_public_ssh_key,
    microk8s_channel : var.microk8s_channel,
    admin_user : var.admin_user,
    microk8s_config : templatefile("${path.module}/templates/microk8s-config.tftpl", {
      node_ip : var.private_worker_node_ips[count.index],
      api_server_domain : local.kube_api_server_domain
    })
  })
  shutdown_before_deletion = true

  network {
    network_id = var.network_id
    ip         = var.private_worker_node_ips[count.index]
    alias_ips  = []
  }

  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
}

resource "null_resource" "join_workers" {
  count = var.number_worker_nodes

  triggers = {
    rerun = random_id.cluster_token.hex
  }
  connection {
    host        = element(hcloud_server_network.worker_private.*.ip, count.index)
    user        = "root"
    type        = "ssh"
    private_key = var.terraform_private_ssh_key
    timeout     = "20m"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "while [[ $(cat /tmp/current_joining_worker_node.txt) != \"${count.index}\" ]]; do echo \"${count.index} is waiting...\";sleep 5;done"
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/join-worker.sh",
      {
        cluster_token = random_id.cluster_token.hex
        main_node_ip  = hcloud_server_network.manager_private[0].ip
    })
    destination = "/usr/local/bin/join-worker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /usr/local/bin/join-worker.sh"
    ]
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "echo \"${count.index + 1}\" > /tmp/current_joining_worker_node.txt"
  }

  depends_on = [null_resource.setup_tokens, null_resource.join_nodes]
}