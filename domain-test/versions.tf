terraform {
  cloud {
    organization = "2martens"

    workspaces {
      name = "domain-test"
    }
  }
  required_providers {
    inwx = {
      source  = "inwx/inwx"
      version = "1.4.2"
    }
  }
}