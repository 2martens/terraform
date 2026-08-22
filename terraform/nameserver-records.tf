resource "hcloud_zone" "twomartens_de" {
  name = "2martens.de"
  mode = "primary"

  ttl = 86400

  delete_protection = true
}

module "medium_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "medium"
  ipv4      = "162.159.153.4"
  ipv6      = "2606:4700:7::a29f:9804"
}

module "nas_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "nas"
  ipv4      = "31.19.63.181"
  ipv6      = "2a02:8108:c19:c400:9209:d0ff:fe70:7570"
}

module "at_proto_domain" {
  source       = "./modules/domain"
  domain       = hcloud_zone.twomartens_de.name
  subdomain    = "_atproto"
  hasIPRecords = false
  txtValues = [
    "did=did:plc:dboupmredm5i3vktwci6nbip"
  ]
}

resource "hcloud_zone_rrset" "twomartens_de_proton_domainkey" {
  name = "protonmail._domainkey"
  type = "CNAME"
  zone = hcloud_zone.twomartens_de.name
  ttl  = 3600

  records = [
    { value = "protonmail.domainkey.d7qwdnpxvruufupuqhrbyqevavmbiqof76ykxlmdzpmspplifzv5q.domains.proton.ch." }
  ]
}

resource "hcloud_zone_rrset" "twomartens_de_proton_domainkey2" {
  name = "protonmail2._domainkey"
  type = "CNAME"
  zone = hcloud_zone.twomartens_de.name
  ttl  = 3600

  records = [
    { value = "protonmail2.domainkey.d7qwdnpxvruufupuqhrbyqevavmbiqof76ykxlmdzpmspplifzv5q.domains.proton.ch." }
  ]
}


resource "hcloud_zone_rrset" "twomartens_de_proton_domainkey3" {
  name = "protonmail3._domainkey"
  type = "CNAME"
  zone = hcloud_zone.twomartens_de.name
  ttl  = 3600

  records = [
    { value = "protonmail3.domainkey.d7qwdnpxvruufupuqhrbyqevavmbiqof76ykxlmdzpmspplifzv5q.domains.proton.ch." }
  ]
}

resource "hcloud_zone_rrset" "twomartens_de_dmarc" {
  name = "_dmarc"
  type = "TXT"
  zone = hcloud_zone.twomartens_de.name
  ttl  = 3600

  records = [
    { value = provider::hcloud::txt_record("v=DMARC1; p=quarantine; rua=mailto:dmarc@alias.2martens.de") }
  ]
}

resource "hcloud_zone_rrset" "alias_mx" {
  zone = hcloud_zone.twomartens_de.name
  name = "alias"
  type = "MX"
  ttl  = 3600

  records = [
    { value = format("%s %s.", 10, "mx1.alias.proton.me") },
    { value = format("%s %s.", 20, "mx2.alias.proton.me") }
  ]
}

resource "hcloud_zone_rrset" "alias_txt" {
  zone = hcloud_zone.twomartens_de.name
  name = "alias"
  type = "TXT"
  ttl  = 3600

  records = [
    { value = provider::hcloud::txt_record("pm-verification=xcouvgmuvrdhisbnndwobyxwusgeah") },
    { value = provider::hcloud::txt_record("v=spf1 include:alias.proton.me ~all") },
  ]
}

resource "hcloud_zone_rrset" "alias_dmarc" {
  zone = hcloud_zone.twomartens_de.name
  name = "_dmarc.alias"
  type = "TXT"
  ttl  = 3600

  records = [
    { value = provider::hcloud::txt_record("v=DMARC1; p=quarantine; pct=100; adkim=s; aspf=s; rua=mailto:dmarc@alias.2martens.de") },
  ]
}

resource "hcloud_zone_rrset" "alias_dkim1" {
  zone = hcloud_zone.twomartens_de.name
  name = "dkim._domainkey.alias"
  type = "CNAME"
  ttl  = 3600

  records = [
    { value = "dkim._domainkey.alias.proton.me." },
  ]
}

resource "hcloud_zone_rrset" "alias_dkim2" {
  zone = hcloud_zone.twomartens_de.name
  name = "dkim02._domainkey.alias"
  type = "CNAME"
  ttl  = 3600

  records = [
    { value = "dkim02._domainkey.alias.proton.me." },
  ]
}

resource "hcloud_zone_rrset" "alias_dkim3" {
  zone = hcloud_zone.twomartens_de.name
  name = "dkim03._domainkey.alias"
  type = "CNAME"
  ttl  = 3600

  records = [
    { value = "dkim03._domainkey.alias.proton.me." },
  ]
}

module "cdn_domain" {
  source            = "./modules/aws_cdn"
  domain            = hcloud_zone.twomartens_de.name
  subdomain         = "cdn"
  cname_target      = "d1fvxyvcoii67h.cloudfront.net."
  validation_key    = "_4741e2d9c8a605950eebfa048029e4ef"
  validation_target = "_cf71e85bb40cc12717f2718e4590ad23.acm-validations.aws."
}
