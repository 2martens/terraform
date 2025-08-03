// data sources

data "hcloud_placement_group" "default" {
  name = "default"
}

// common resources

resource "hcloud_network" "kubernetes-network" {
  name              = "kubernetes"
  ip_range          = "10.0.0.0/8"
  delete_protection = true
}

resource "hcloud_network_subnet" "k8s-network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.kubernetes-network.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/16"
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
    protocol    = "icmp"
    description = "allow ICMP"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
}

resource "hcloud_firewall" "http-firewall" {
  name = "http-firewall"

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