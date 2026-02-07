terraform {
  cloud {
    organization = "2martens"

    workspaces {
      name = "cloud-configuration"
    }
  }
  required_providers {
    inwx = {
      source  = "inwx/inwx"
      version = "1.6.4"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.44.1"
    }
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.1.0"
    }
  }
}