resource "inwx_nameserver_record" "manager_aaaa" {
  count = var.number_nodes

  domain  = var.domain
  name    = format("%s-%d.%s", "node", count.index, local.kube_api_server_domain)
  content = hcloud_server.manager[count.index].ipv6_address
  type    = "AAAA"
  ttl     = 3600
}

resource "hcloud_primary_ip" "ipv4_manager_address" {
  count = var.create_loadbalancer ? 0 : var.number_nodes

  name          = format("%s_%s_%s_%d", "k8s", var.cluster_name, "ipv4", count.index)
  datacenter    = element(var.locations.*.datacenter_name, count.index)
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_rdns" "ipv4_manager" {
  count = var.create_loadbalancer ? 0 : var.number_nodes

  primary_ip_id = hcloud_primary_ip.ipv4_manager_address[count.index].id
  ip_address    = hcloud_primary_ip.ipv4_manager_address[count.index].ip_address
  dns_ptr       = inwx_nameserver_record.manager_aaaa[count.index].name
}

resource "hcloud_primary_ip" "ipv6_manager_address" {
  count = var.number_nodes

  name          = format("%s_%s_%s_%d", "k8s", var.cluster_name, "ipv6", count.index)
  datacenter    = element(var.locations.*.datacenter_name, count.index)
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_rdns" "ipv6_manager" {
  count = var.number_nodes

  primary_ip_id = hcloud_primary_ip.ipv6_manager_address[count.index].id
  ip_address    = hcloud_server.manager[count.index].ipv6_address
  dns_ptr       = inwx_nameserver_record.manager_aaaa[count.index].name
}

resource "hcloud_server_network" "manager_private" {
  count = var.number_nodes

  server_id = hcloud_server.manager[count.index].id
  subnet_id = var.server_subnet_id
  ip        = var.private_node_ips[count.index]
}

resource "hcloud_server" "manager" {
  count = var.number_nodes

  name                    = format("%s-%s-%s-%d", "k8s", var.cluster_name, "node", count.index)
  image                   = var.image_name
  allow_deprecated_images = false
  server_type             = var.server_type
  location                = element(var.locations.*.name, count.index)

  public_net {
    ipv4_enabled = var.create_loadbalancer ? false : true
    ipv4         = var.create_loadbalancer ? null : hcloud_primary_ip.ipv4_manager_address[count.index].id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.ipv6_manager_address[count.index].id
  }

  ignore_remote_firewall_ids = false
  keep_disk                  = false
  placement_group_id         = data.hcloud_placement_group.default.id
  firewall_ids               = [var.basic_firewall_id, var.k8s_firewall_id]
  ssh_keys                   = [var.admin_ssh_key.id]
  shutdown_before_deletion   = true

  labels = {
    "kubernetes" : "yes",
    "manager" : "yes"
  }

  user_data = templatefile("${path.module}/templates/cloud-init-k8s-manager.tftpl", {
    admin_public_ssh_key : format("%s %s", var.admin_ssh_key.public_key, var.admin_ssh_key.name)
    admin_user : var.admin_user
    terraform_public_ssh_key : var.terraform_public_ssh_key
    main_node : count.index == 0
    microk8s_config : base64encode(templatefile("${path.module}/templates/snap/microk8s-config-manager.tftpl", {
      node_ip : var.private_node_ips[count.index]
      api_server_domain : local.kube_api_server_domain
      main_node : count.index == 0
      main_node_ip : var.private_node_ips[0]
      api_server_ip : var.create_loadbalancer ? hcloud_load_balancer.kubernetes[0].ipv4 : hcloud_primary_ip.ipv4_manager_address[0].ip_address
      cluster_token : random_id.cluster_token.hex
    }))
    snapcraft : base64encode(file("${path.module}/templates/snap/snapcraft.yaml"))
    packages_setup : base64encode(templatefile("${path.module}/templates/scripts/install-packages.sh", {
      refresh_day : "fri"
      refresh_hour : format("%02d", count.index)
    }))
    firewall_setup : base64encode(templatefile("${path.module}/templates/scripts/firewall-setup.sh", {
      node_ip : var.private_node_ips[count.index]
    }))
    ssh_setup : base64encode(templatefile("${path.module}/templates/scripts/ssh-setup.sh", {
      admin_user : var.admin_user
    }))
    microk8s_setup : base64encode(templatefile("${path.module}/templates/scripts/microk8s-setup.sh", {
      microk8s_channel : var.microk8s_channel
      main_node = count.index == 0
      manager_node : true
    }))
    cluster_setup_values : base64encode(templatefile("${path.module}/templates/helm/cluster-setup-values.yaml", {
      client_id : var.vault_service_principal.client_id
      client_secret : var.vault_service_principal.client_secret
    }))
    argocd_ha_values : base64encode(file("${path.module}/templates/helm/argocd-values-ha.yaml"))
    cluster_setup : base64encode(templatefile("${path.module}/templates/scripts/cluster-setup.sh", {
      argocd_environment : var.argocd_environment
      argocd_version : var.argocd_chart_version
      high_availability : var.number_nodes > 2
      admin_user : var.admin_user
    }))
  })

  network {
    network_id = var.network_id
    ip         = var.private_node_ips[count.index]
    alias_ips  = []
  }

  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
}

resource "random_id" "cluster_token" {
  byte_length = 16
}

#resource "null_resource" "setup_tokens" {
#  count = var.number_nodes > 1 ? 1 : 0
#
#  triggers = {
#    rerun = random_id.cluster_token.hex
#  }
#
#  connection {
#    host        = hcloud_server.manager[0].ipv6_address
#    user        = "terraform"
#    type        = "ssh"
#    private_key = var.terraform_private_ssh_key
#    timeout     = "10m"
#  }
#
#  provisioner "local-exec" {
#    interpreter = ["bash", "-c"]
#    command     = <<EOT
#        echo "1" > /tmp/current_joining_node.txt
#        echo "0" > /tmp/current_joining_worker_node.txt
#        EOT
#  }
#
#  provisioner "file" {
#    content = templatefile("${path.module}/templates/add-node.sh",
#      {
#        cluster_token             = random_id.cluster_token.hex
#        cluster_token_ttl_seconds = var.cluster_token_ttl_seconds
#    })
#    destination = "/usr/local/bin/add-node.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sh /usr/local/bin/add-node.sh",
#    ]
#  }
#}
#
#
#resource "null_resource" "join_nodes" {
#  count = var.number_nodes - 1 < 1 ? 0 : var.number_nodes - 1
#
#  triggers = {
#    rerun = random_id.cluster_token.hex
#  }
#  connection {
#    host        = element(hcloud_server.manager.*.ipv6_address, count.index + 1)
#    user        = "terraform"
#    type        = "ssh"
#    private_key = var.terraform_private_ssh_key
#    timeout     = "20m"
#  }
#
#  provisioner "local-exec" {
#    interpreter = ["bash", "-c"]
#    command     = "while [[ $(cat /tmp/current_joining_node.txt) != \"${count.index + 1}\" ]]; do echo \"${count.index + 1} is waiting...\";sleep 5;done"
#  }
#
#  provisioner "file" {
#    content = templatefile("${path.module}/templates/join.sh",
#      {
#        cluster_token = random_id.cluster_token.hex
#        main_node_ip  = hcloud_server_network.manager_private[0].ip
#    })
#    destination = "/usr/local/bin/join.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sh /usr/local/bin/join.sh"
#    ]
#  }
#
#  provisioner "local-exec" {
#    interpreter = ["bash", "-c"]
#    command     = "echo \"${count.index + 2}\" > /tmp/current_joining_node.txt"
#  }
#
#  depends_on = [null_resource.setup_tokens]
#}