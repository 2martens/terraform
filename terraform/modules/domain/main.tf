resource "hcloud_zone_rrset" "a" {
  count = var.hasIPRecords ? 1 : 0

  zone = var.domain
  name = var.subdomain != "" ? var.subdomain : "@"
  type = "A"
  ttl  = 3600

  change_protection = true

  records = [
    { value = var.ipv4 }
  ]
}

resource "hcloud_zone_rrset" "aaaa" {
  count = var.hasIPRecords ? 1 : 0

  zone = var.domain
  name = var.subdomain != "" ? var.subdomain : "@"
  type = "AAAA"
  ttl  = 3600

  change_protection = true

  records = [
    { value = var.ipv6 }
  ]
}

resource "hcloud_zone_rrset" "mx" {
  count = var.hasMXRecord ? 1 : 0

  zone = var.domain
  name = var.subdomain != "" ? var.subdomain : "@"
  type = "MX"
  ttl  = 3600

  change_protection = true

  records = [
    { value = format("%s %s.", var.mxPrio, var.hostName) }
  ]
}

resource "hcloud_zone_rrset" "txt" {
  count = length(var.txtValues) > 0 ? 1 : 0

  zone = var.domain
  name = var.subdomain != "" ? var.subdomain : "@"
  type = "TXT"
  ttl  = 3600

  change_protection = false

  records = [
    for txtValue in var.txtValues :
    { value = provider::hcloud::txt_record(txtValue) }
  ]
}

resource "hcloud_zone_rrset" "uberspace_domain_key" {
  count = var.uberspaceDomainKey != "" ? 1 : 0

  zone = var.domain
  name = var.subdomain != "" ? format("%s.%s", "uberspace._domainkey", var.subdomain) : "uberspace._domainkey"
  type = "TXT"
  ttl  = 3600

  change_protection = true

  records = [
    { value = provider::hcloud::txt_record(var.uberspaceDomainKey) }
  ]
}
