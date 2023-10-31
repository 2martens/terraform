locals {
  domain_period  = "1Y"
  domain_renewal = "AUTORENEW"
}

resource "inwx_domain_contact" "admin" {
  // contact configuration
  type             = "PERSON"
  name             = var.admin_name
  street_address   = var.admin_street
  city             = var.admin_city
  postal_code      = var.admin_postal_code
  country_code     = var.admin_country_code
  phone_number     = var.admin_phone_number
  email            = var.admin_email
  whois_protection = true
}

resource "inwx_domain" "twomartens_de" {
  name = "2martens.de"
  nameservers = [
    "ns.inwx.de",
    "ns2.inwx.de",
    "ns3.inwx.eu"
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

resource "inwx_domain" "twomartens_eu" {
  name = "2martens.eu"
  nameservers = [
    "ns.inwx.de",
    "ns2.inwx.de",
    "ns3.inwx.eu"
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
  extra_data = {
    "EU-COUNTRY-OF-CITIZENSHIP" : "DE"
  }
}

// NS records
resource "inwx_nameserver_record" "twomartens_de_ns1" {
  domain  = "2martens.de"
  name    = "2martens.de"
  content = "ns.inwx.de"
  type    = "NS"
  ttl     = 86400
}

resource "inwx_nameserver_record" "twomartens_de_ns2" {
  domain  = "2martens.de"
  name    = "2martens.de"
  content = "ns2.inwx.de"
  type    = "NS"
  ttl     = 86400
}

resource "inwx_nameserver_record" "twomartens_de_ns3" {
  domain  = "2martens.de"
  name    = "2martens.de"
  content = "ns3.inwx.eu"
  type    = "NS"
  ttl     = 86400
}

resource "inwx_nameserver_record" "twomartens_eu_ns1" {
  domain  = "2martens.eu"
  name    = "2martens.eu"
  content = "ns.inwx.de"
  type    = "NS"
  ttl     = 86400
}

resource "inwx_nameserver_record" "twomartens_eu_ns2" {
  domain  = "2martens.eu"
  name    = "2martens.eu"
  content = "ns2.inwx.de"
  type    = "NS"
  ttl     = 86400
}

resource "inwx_nameserver_record" "twomartens_eu_ns3" {
  domain  = "2martens.eu"
  name    = "2martens.eu"
  content = "ns3.inwx.eu"
  type    = "NS"
  ttl     = 86400
}

// SOAs

resource "inwx_nameserver_record" "twomartens_de_soa" {
  domain  = "2martens.de"
  name    = "2martens.de"
  content = "ns.inwx.de hostmaster.inwx.de 2023103008 10800 3600 604800 3600"
  type    = "SOA"
  ttl     = 86400
}

resource "inwx_nameserver_record" "twomartens_eu_soa" {
  domain  = "2martens.eu"
  name    = "2martens.eu"
  content = "ns.inwx.de hostmaster.inwx.de 2023103001 10800 3600 604800 3600"
  type    = "SOA"
  ttl     = 86400
}

// redirect 2martens.eu to 2martens.de
resource "inwx_nameserver_record" "twomartens_eu_root_redirect" {
  domain            = "2martens.eu"
  name              = "2martens.eu"
  content           = "https://2martens.de"
  type              = "URL"
  url_redirect_type = "HEADER301"
  prio              = 301
  ttl               = 3600
}
resource "inwx_nameserver_record" "twomartens_eu_www_redirect" {
  domain            = "2martens.eu"
  name              = "www.2martens.eu"
  content           = "https://2martens.de"
  type              = "URL"
  url_redirect_type = "HEADER301"
  prio              = 301
  ttl               = 3600
}