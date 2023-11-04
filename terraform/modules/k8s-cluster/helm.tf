resource "null_resource" "install_setup" {
  connection {
    host        = format("%s%d", hcloud_server.manager[0].ipv6_address, 1)
    user        = "root"
    type        = "ssh"
    private_key = var.terraform_private_ssh_key
    timeout     = "2m"
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/cluster-setup-values.yaml", {
      client_id : var.vault_service_principal.client_id,
      client_secret : var.vault_service_principal.client_secret
    })
    destination = "/home/terraform/cluster-setup-values.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "helm repo add 2martens https://repo.2martens.de/charts/",
      "helm install setup 2martens/cluster_setup --values /home/terraform/cluster-setup-values.yaml",
    ]
  }

  depends_on = [null_resource.join_nodes, hcloud_server.manager]
}

resource "inwx_nameserver_record" "argocd_a" {
  domain  = var.domain
  name    = format("%s.%s", "argocd", local.kube_api_server_domain)
  content = inwx_nameserver_record.kube_api_server_a.content
  type    = "A"
  ttl     = 3600
}
resource "inwx_nameserver_record" "argocd_aaaa" {
  domain  = var.domain
  name    = format("%s.%s", "argocd", local.kube_api_server_domain)
  content = inwx_nameserver_record.kube_api_server_aaaa.content
  type    = "AAAA"
  ttl     = 3600
}

resource "null_resource" "install_argocd_single" {
  count = var.number_nodes < 3 ? 1 : 0

  connection {
    host        = format("%s%d", hcloud_server.manager[0].ipv6_address, 1)
    user        = "root"
    type        = "ssh"
    private_key = var.terraform_private_ssh_key
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "helm repo add 2martens https://repo.2martens.de/charts/",
      "helm install setup 2martens/cluster_setup",
      "helm install argocd 2martens/argocd --set environment=${var.argocd_environment}",
    ]
  }

  depends_on = [null_resource.join_nodes, hcloud_server.manager]
}

resource "null_resource" "install_argocd_ha" {
  count = var.number_nodes >= 3 ? 1 : 0

  connection {
    host        = format("%s%d", hcloud_server.manager[0].ipv6_address, 1)
    user        = "root"
    type        = "ssh"
    private_key = var.terraform_private_ssh_key
    timeout     = "2m"
  }

  provisioner "file" {
    content     = file("${path.module}/templates/argocd-values-ha.yaml")
    destination = "/home/terraform/argocd-values-ha.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "helm repo add 2martens https://repo.2martens.de/charts/",
      "helm install setup 2martens/cluster_setup",
      "helm install argocd 2martens/argocd --set environment=${var.argocd_environment} --values /home/terraform/argocd-values-ha.yaml",
    ]
  }

  depends_on = [null_resource.join_nodes, hcloud_server.manager]
}