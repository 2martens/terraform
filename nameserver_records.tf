// A records
resource "inwx_nameserver_record" "twomartens_de_allris_a" {
  domain  = "2martens.de"
  name    = "allris.2martens.de"
  content = "185.26.156.105"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_autoconfig_a" {
  domain  = "2martens.de"
  name    = "autoconfig.2martens.de"
  content = "185.26.156.22"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_autodiscover_a" {
  domain  = "2martens.de"
  name    = "autodiscover.2martens.de"
  content = "185.26.156.22"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_jim_a" {
  domain  = "2martens.de"
  name    = "jim.2martens.de"
  content = "185.26.156.65"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_pad_a" {
  domain  = "2martens.de"
  name    = "pad.2martens.de"
  content = "185.26.156.132"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_short_a" {
  domain  = "2martens.de"
  name    = "short.2martens.de"
  content = "95.143.172.56"
  type    = "A"
  ttl     = 3600
}

// AAAA records

resource "inwx_nameserver_record" "twomartens_de_allris_aaaa" {
  domain  = "2martens.de"
  name    = "allris.2martens.de"
  content = "2a00:d0c0:200:0:b9:1a:9c:61"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_autoconfig_aaaa" {
  domain  = "2martens.de"
  name    = "autoconfig.2martens.de"
  content = "2a00:d0c0:200:0:b9:1a:9c16:5d"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_autodiscover_aaaa" {
  domain  = "2martens.de"
  name    = "autodiscover.2martens.de"
  content = "2a00:d0c0:200:0:b9:1a:9c16:5d"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_jim_aaaa" {
  domain  = "2martens.de"
  name    = "jim.2martens.de"
  content = "2a00:d0c0:200:0:b9:1a:9c:40"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_pad_aaaa" {
  domain  = "2martens.de"
  name    = "pad.2martens.de"
  content = "2a00:d0c0:200:0:c0bf:e0ff:fec1:af72"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_short_aaaa" {
  domain  = "2martens.de"
  name    = "short.2martens.de"
  content = "2001:1a50:11:0:3854:d4ff:fe62:e0d8"
  type    = "AAAA"
  ttl     = 3600
}

// CNAME records

resource "inwx_nameserver_record" "twomartens_de_cdn_cname" {
  domain  = "2martens.de"
  name    = "cdn.2martens.de"
  content = "d1fvxyvcoii67h.cloudfront.net"
  type    = "CNAME"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_de_aws-validations-cdn_cname" {
  domain  = "2martens.de"
  name    = "_4741e2d9c8a605950eebfa048029e4ef.cdn.2martens.de"
  content = "_cf71e85bb40cc12717f2718e4590ad23.acm-validations.aws"
  type    = "CNAME"
  ttl     = 3600
}
