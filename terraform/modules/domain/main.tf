terraform {
  required_providers {
    inwx = {
      source  = "inwx/inwx"
      version = "1.3.2"
    }
  }
}

resource "inwx_nameserver_record" "a" {
  domain  = var.domain
  name    = var.subdomain != "" ? format("%s.%s", var.subdomain, var.domain) : var.domain
  content = var.ipv4
  type    = "A"
  ttl     = 3600
}
resource "inwx_nameserver_record" "aaaa" {
  domain  = var.domain
  name    = var.subdomain != "" ? format("%s.%s", var.subdomain, var.domain) : var.domain
  content = var.ipv6
  type    = "AAAA"
  ttl     = 3600
}
resource "inwx_nameserver_record" "mx" {
  domain  = var.domain
  name    = var.subdomain != "" ? format("%s.%s", var.subdomain, var.domain) : var.domain
  content = var.hostName
  type    = "MX"
  prio    = var.mxPrio
  ttl     = 3600
  count   = var.hasMXRecord ? 1 : 0
}
resource "inwx_nameserver_record" "mx-spf" {
  domain  = var.domain
  name    = var.subdomain != "" ? format("%s.%s", var.subdomain, var.domain) : var.domain
  content = var.mxSpf
  type    = "TXT"
  ttl     = 3600
  count   = var.hasMXRecord ? 1 : 0
}