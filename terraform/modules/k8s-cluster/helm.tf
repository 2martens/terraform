resource "null_resource" "install_setup" {
  connection {
    host        = hcloud_server_network.manager_private[0].ip
    user        = "root"
    type        = "ssh"
    private_key = var.terraform_private_ssh_key
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "helm repo add 2martens https://repo.2martens.de/charts/",
      "helm install setup 2martens/cluster_setup",
    ]
  }

  depends_on = [null_resource.join_nodes, hcloud_server.manager]
}

resource "null_resource" "install_argocd_single" {
  count = var.number_nodes < 3 ? 1 : 0

  connection {
    host        = hcloud_server_network.manager_private[0].ip
    user        = "root"
    type        = "ssh"
    private_key = var.terraform_private_ssh_key
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "helm repo add 2martens https://repo.2martens.de/charts/",
      "helm install setup 2martens/cluster_setup",
      "helm install argocd 2martens/argocd",
    ]
  }

  depends_on = [null_resource.join_nodes, hcloud_server.manager]
}

resource "null_resource" "install_argocd_ha" {
  count = var.number_nodes >= 3 ? 1 : 0

  connection {
    host        = hcloud_server_network.manager_private[0].ip
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
      "helm install argocd 2martens/argocd --values /home/terraform/argocd-values-ha.yaml",
    ]
  }

  depends_on = [null_resource.join_nodes, hcloud_server.manager]
}