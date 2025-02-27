locals {
  domain_period  = "1Y"
  domain_renewal = "AUTORENEW"
}

resource "inwx_domain_contact" "admin" {
  // contact configuration
  type           = "PERSON"
  name           = var.admin_name
  street_address = var.admin_street
  city           = var.admin_city
  postal_code    = var.admin_postal_code
  country_code   = var.admin_country_code
  phone_number   = var.admin_phone_number
  email          = var.admin_email
}

resource "inwx_nameserver" "twomartens_example_nameserver" {
  domain = local.domain
  type   = "MASTER"
  nameservers = [
    "ns.ote.inwx.de",
    "ns2.ote.inwx.de"
  ]
}

resource "inwx_domain" "twomartens_example" {
  name = local.domain
  nameservers = [
    "ns.ote.inwx.de",
    "ns2.ote.inwx.de"
  ]
  period        = local.domain_period
  renewal_mode  = local.domain_renewal
  transfer_lock = true
  contacts {
    // references to terraform managed contact "example_person"
    registrant = inwx_domain_contact.admin.id
    admin      = inwx_domain_contact.admin.id
    tech       = 1
    billing    = 1
  }
}

// NS records
resource "inwx_nameserver_record" "twomartens_example_ns1" {
  domain  = local.domain
  name    = local.domain
  content = "ns.ote.inwx.de"
  type    = "NS"
  ttl     = 86400
}

resource "inwx_nameserver_record" "twomartens_example_ns2" {
  domain  = local.domain
  name    = local.domain
  content = "ns2.ote.inwx.de"
  type    = "NS"
  ttl     = 86400
}


// SOAs

# resource "inwx_nameserver_record" "twomartens_de_soa" {
#   domain  = local.domain
#   name    = local.domain
#   content = "ns.inwx.de hostmaster.inwx.de 2023103008 10800 3600 604800 3600"
#   type    = "SOA"
#   ttl     = 86400
#
#   lifecycle {
#     ignore_changes = [content]
#   }
# }

# resource "inwx_nameserver_record" "twomartens_eu_soa" {
#   domain  = "2martens.eu"
#   name    = "2martens.eu"
#   content = "ns.inwx.de hostmaster.inwx.de 2023103001 10800 3600 604800 3600"
#   type    = "SOA"
#   ttl     = 86400
#
#   lifecycle {
#     ignore_changes = [content]
#   }
# }
