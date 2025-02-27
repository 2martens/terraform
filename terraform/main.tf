data "hcloud_location" "falkenstein" {
  name = "fsn1"
}

data "hcloud_location" "nuremberg" {
  name = "nbg1"
}

data "hcloud_datacenter" "falkenstein" {
  name = "fsn1-dc14"
}

data "hcloud_datacenter" "nuremberg" {
  name = "nbg1-dc3"
}

data "hcloud_ssh_key" "macos" {
  name = "2martens@Jims-Air.fritz.box"
}

locals {
  domain             = "2martens.de"
  test_cluster       = "test"
  monitoring_cluster = "monitoring"
}

module "test_cluster" {
  source = "./modules/k8s-cluster"

  admin_ssh_key             = data.hcloud_ssh_key.macos
  admin_user                = "2martensAdmin"
  admin_email               = "admin@2martens.de"
  terraform_public_ssh_key  = var.terraform_public_ssh_key
  terraform_private_ssh_key = var.terraform_private_ssh_key
  basic_firewall_id         = hcloud_firewall.basic-firewall.id
  k8s_firewall_id           = hcloud_firewall.k8s-firewall.id
  locations = [
    {
      id              = data.hcloud_location.falkenstein.id,
      name            = data.hcloud_location.falkenstein.name,
      datacenter_name = data.hcloud_datacenter.falkenstein.name,
      network_zone    = data.hcloud_location.falkenstein.network_zone
    }, {
      id              = data.hcloud_location.nuremberg.id,
      name            = data.hcloud_location.nuremberg.name,
      datacenter_name = data.hcloud_datacenter.nuremberg.name,
      network_zone    = data.hcloud_location.nuremberg.network_zone
    }
  ]
  domain     = local.domain
  network_id = hcloud_network.kubernetes-network.id
  private_node_ips = [
    cidrhost(hcloud_network_subnet.k8s-network-subnet.ip_range, 4),
    cidrhost(hcloud_network_subnet.k8s-network-subnet.ip_range, 5),
    cidrhost(hcloud_network_subnet.k8s-network-subnet.ip_range, 6)
  ]
  server_subnet_id    = hcloud_network_subnet.k8s-network-subnet.id
  cluster_name        = local.test_cluster
  argocd_environment  = "test"
  number_nodes        = 1
  server_type         = "cax21"
  image_name          = "ubuntu-22.04"
  create_loadbalancer = false
  loadbalancer_ip = cidrhost(hcloud_network_subnet.k8s-network-subnet.ip_range, 3)
  vault_service_principal = {
    client_id : var.vault_client_id
    client_secret : var.vault_client_secret
  }
  vault_allowed_namespaces = ["wahlrecht", "timetable", "hcloud", "routing"]
  hcloud_token_enabled          = false
  hcloud_token                  = var.hcloud_token
  thanos_enabled                = true
  thanos_s3_bucket_name         = "2martens-thanos-store"
  aws_access_key                = var.aws_access_key
  aws_secret_key                = var.aws_secret_key
  argocd_keycloak_client_secret = var.argocd_test_keycloak_client_secret
  argocd_domain                 = "argocd.k8s.test.2martens.de"
}

module "monitoring_cluster" {
  source = "./modules/k8s-cluster"

  admin_ssh_key             = data.hcloud_ssh_key.macos
  admin_user                = "2martensAdmin"
  admin_email               = "admin@2martens.de"
  terraform_public_ssh_key  = var.terraform_public_ssh_key
  terraform_private_ssh_key = var.terraform_private_ssh_key
  basic_firewall_id         = hcloud_firewall.basic-firewall.id
  k8s_firewall_id           = hcloud_firewall.k8s-firewall.id
  locations = [
    {
      id              = data.hcloud_location.falkenstein.id,
      name            = data.hcloud_location.falkenstein.name,
      datacenter_name = data.hcloud_datacenter.falkenstein.name,
      network_zone    = data.hcloud_location.falkenstein.network_zone
    }, {
      id              = data.hcloud_location.nuremberg.id,
      name            = data.hcloud_location.nuremberg.name,
      datacenter_name = data.hcloud_datacenter.nuremberg.name,
      network_zone    = data.hcloud_location.nuremberg.network_zone
    }
  ]
  domain     = local.domain
  network_id = hcloud_network.kubernetes-network.id
  private_node_ips = [
    cidrhost(hcloud_network_subnet.k8s-network-subnet.ip_range, 7),
  ]
  server_subnet_id    = hcloud_network_subnet.k8s-network-subnet.id
  cluster_name        = local.monitoring_cluster
  argocd_environment  = "monitoring"
  number_nodes        = 1
  server_type         = "cax21"
  image_name          = "ubuntu-22.04"
  create_loadbalancer = false
  loadbalancer_ip = cidrhost(hcloud_network_subnet.k8s-network-subnet.ip_range, 3)
  vault_service_principal = {
    client_id : var.vault_client_id
    client_secret : var.vault_client_secret
  }
  vault_allowed_namespaces = ["hcloud"]
  hcloud_token_enabled          = false
  hcloud_token                  = var.hcloud_token
  thanos_enabled                = true
  thanos_s3_bucket_name         = "2martens-thanos-store"
  aws_access_key                = var.aws_access_key
  aws_secret_key                = var.aws_secret_key
  argocd_keycloak_client_secret = var.argocd_monitoring_keycloak_client_secret
  argocd_domain                 = "argocd.k8s.monitoring.2martens.de"
}