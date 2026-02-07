resource "hcloud_zone_rrset" "cname" {
  zone = var.domain
  name = var.subdomain != "" ? var.subdomain : "@"
  type = "CNAME"
  ttl  = 3600

  change_protection = true

  records = [
    { value = var.cname_target }
  ]
}

resource "hcloud_zone_rrset" "validation" {
  zone = var.domain
  name = var.subdomain != "" ? format("%s.%s", var.validation_key, var.subdomain) : var.validation_key
  type = "CNAME"
  ttl  = 3600

  change_protection = true

  records = [
    { value = var.validation_target }
  ]
}