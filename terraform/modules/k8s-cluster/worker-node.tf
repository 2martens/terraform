resource "inwx_nameserver_record" "worker_aaaa" {
  count = var.number_worker_nodes

  domain  = var.domain
  name    = format("%s-%d.%s", "node", count.index, local.kube_api_server_domain)
  content = hcloud_server.worker[count.index].ipv6_address
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

resource "hcloud_rdns" "ipv6_worker" {
  count = var.number_worker_nodes

  primary_ip_id = hcloud_primary_ip.ipv6_worker_address[count.index].id
  ip_address    = hcloud_server.worker[count.index].ipv6_address
  dns_ptr       = inwx_nameserver_record.worker_aaaa[count.index].name
}

resource "hcloud_server_network" "worker_private" {
  count = var.number_worker_nodes

  server_id = hcloud_server.worker[count.index].id
  subnet_id = var.server_subnet_id
  ip        = var.private_worker_node_ips[count.index]
}

resource "hcloud_server" "worker" {
  count = var.number_worker_nodes

  name                    = format("%s-%s-%s-%d", "k8s", var.cluster_name, "node", count.index)
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
  firewall_ids               = [var.basic_firewall_id, var.k8s_firewall_id]
  ssh_keys                   = [var.admin_ssh_key.id]
  shutdown_before_deletion   = true

  labels = {
    "kubernetes" : "yes",
    "worker" : "yes"
  }

  user_data = templatefile("${path.module}/templates/cloud-init-k8s-worker.tftpl", {
    admin_public_ssh_key : format("%s %s", var.admin_ssh_key.public_key, var.admin_ssh_key.name)
    admin_user : var.admin_user
    terraform_public_ssh_key : var.terraform_public_ssh_key
    main_node : count.index == 0
    microk8s_config : base64encode(templatefile("${path.module}/templates/snap/microk8s-config-worker.tftpl", {
      node_ip : var.private_node_ips[count.index]
      api_server_domain : local.kube_api_server_domain
      main_node : count.index == 0
      main_node_ip : hcloud_server_network.manager_private[0].ip
      api_server_ip : var.create_loadbalancer ? hcloud_load_balancer.kubernetes[0].ipv4 : hcloud_server.manager[0].ipv4_address
      cluster_token : random_id.cluster_token.hex
    }))
    snapcraft : base64encode(file("${path.module}/templates/snap/snapcraft.yaml"))
    packages_setup : base64encode(templatefile("${path.module}/templates/scripts/install-packages.sh", {
      refresh_day : "sat"
      refresh_hour : format("%02d", count.index)
    }))
    firewall_setup : base64encode(templatefile("${path.module}/templates/scripts/firewall-setup.sh", {
      node_ip : var.private_node_ips[count.index]
    }))
    ssh_setup : base64encode(templatefile("${path.module}/templates/scripts/ssh-setup.sh", {
      admin_user : var.admin_user
    }))
    sysctl_setup : base64encode(file("${path.module}/templates/scripts/sysctl-setup.sh"))
    microk8s_setup : base64encode(templatefile("${path.module}/templates/scripts/microk8s-setup.sh", {
      microk8s_channel : var.microk8s_channel
      main_node : false
      manager_node : false
    }))
  })

  network {
    network_id = var.network_id
    ip         = var.private_worker_node_ips[count.index]
    alias_ips  = []
  }

  lifecycle {
    ignore_changes = [ssh_keys]
  }
}

#resource "null_resource" "join_workers" {
#  count = var.number_worker_nodes
#
#  triggers = {
#    rerun = random_id.cluster_token.hex
#  }
#  connection {
#    host        = element(hcloud_server.worker.*.ipv6_address, count.index)
#    user        = "terraform"
#    type        = "ssh"
#    private_key = var.terraform_private_ssh_key
#    timeout     = "20m"
#  }
#
#  provisioner "local-exec" {
#    interpreter = ["bash", "-c"]
#    command     = "while [[ $(cat /tmp/current_joining_worker_node.txt) != \"${count.index}\" ]]; do echo \"${count.index} is waiting...\";sleep 5;done"
#  }
#
#  provisioner "file" {
#    content = templatefile("${path.module}/templates/join-worker.sh",
#      {
#        cluster_token = random_id.cluster_token.hex
#        main_node_ip  = hcloud_server_network.manager_private[0].ip
#    })
#    destination = "/usr/local/bin/join-worker.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sh /usr/local/bin/join-worker.sh"
#    ]
#  }
#
#  provisioner "local-exec" {
#    interpreter = ["bash", "-c"]
#    command     = "echo \"${count.index + 1}\" > /tmp/current_joining_worker_node.txt"
#  }
#
#  depends_on = [null_resource.setup_tokens, null_resource.join_nodes]
#}