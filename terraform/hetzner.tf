// data sources

data "hcloud_placement_group" "default" {
  name = "default"
}

// common resources

resource "hcloud_network" "kubernetes-network" {
  name              = "kubernetes"
  ip_range          = "10.0.0.0/8"
  delete_protection = true
  labels = {
    "kubernetes.io/cluster/${local.test_cluster}" : "shared"
  }
}

resource "hcloud_network_subnet" "k8s-network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.kubernetes-network.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/16"
  labels = {
    "kubernetes.io/cluster/${local.test_cluster}" : "shared"
  }
}

resource "hcloud_firewall" "basic-firewall" {
  name = "basic-firewall"
  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    description = "allow SSH"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    description = "allow HTTP"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    description = "allow HTTPS"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    direction   = "in"
    protocol    = "icmp"
    description = "allow ICMP"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
}

resource "hcloud_firewall" "k8s-firewall" {
  name = "k8s-firewall"
  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "16443"
    description = "Access Kubernetes"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
}

// servers
resource "hcloud_primary_ip" "primary_ipv4_devops" {
  name          = "primary_ipv4_devops"
  datacenter    = data.hcloud_datacenter.falkenstein.name
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_primary_ip" "primary_ipv6_devops" {
  name          = "primary_ipv6_devops"
  datacenter    = data.hcloud_datacenter.falkenstein.name
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "server_devops" {
  name                    = "devops"
  image                   = "ubuntu-22.04"
  allow_deprecated_images = false
  server_type             = "cax21"
  location                = data.hcloud_location.falkenstein.name
  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.primary_ipv4_devops.id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.primary_ipv6_devops.id
  }
  ignore_remote_firewall_ids = false
  keep_disk                  = false
  placement_group_id         = data.hcloud_placement_group.default.id
  labels = {
    "apache" : "yes",
    "docker" : "yes",
    "drone" : "yes"
  }
  firewall_ids             = [hcloud_firewall.basic-firewall.id]
  ssh_keys                 = [data.hcloud_ssh_key.macos.id]
  user_data                = file("${path.module}/templates/cloud-init.tftpl")
  shutdown_before_deletion = true

  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
}

module "drone_domain" {
  source    = "./modules/domain"
  domain    = local.domain
  subdomain = "ci"
  ipv4      = "49.12.69.146"
  ipv6      = "2a01:4f8:c012:1fef::1"
}
resource "inwx_nameserver_record" "twomartens_de_ci-ownercheck_txt" {
  domain  = local.domain
  name    = "ownercheck.ci.2martens.de"
  content = "e1eb600b"
  type    = "TXT"
  ttl     = 3600
}