resource "hcloud_zone" "twomartens_de" {
  name = "2martens.de"
  mode = "primary"

  ttl = 86400

  delete_protection = true
}

