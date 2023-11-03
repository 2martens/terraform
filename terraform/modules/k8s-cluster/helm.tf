resource "null_resource" "install_argocd" {
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
      "helm install 2martens/argocd",
    ]
  }

  depends_on = [null_resource.join_nodes, hcloud_server.manager]
}