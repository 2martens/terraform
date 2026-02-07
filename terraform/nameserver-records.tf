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