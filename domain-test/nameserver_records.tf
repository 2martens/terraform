// A records
resource "inwx_nameserver_record" "twomartens_example_allris_a" {
  domain  = local.domain
  name    = format("allris.%s", local.domain)
  content = "185.26.156.105"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_autoconfig_a" {
  domain  = local.domain
  name    = format("autoconfig.%s", local.domain)
  content = "185.26.156.22"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_autodiscover_a" {
  domain  = local.domain
  name    = format("autodiscover.%s", local.domain)
  content = "185.26.156.22"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_jim_a" {
  domain  = local.domain
  name    = format("jim.%s", local.domain)
  content = "185.26.156.65"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_pad_a" {
  domain  = local.domain
  name    = format("pad.%s", local.domain)
  content = "185.26.156.132"
  type    = "A"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_short_a" {
  domain  = local.domain
  name    = format("short.%s", local.domain)
  content = "95.143.172.56"
  type    = "A"
  ttl     = 3600
}

// AAAA records

resource "inwx_nameserver_record" "twomartens_example_allris_aaaa" {
  domain  = local.domain
  name    = format("allris.%s", local.domain)
  content = "2a00:d0c0:200:0:b9:1a:9c:61"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_autoconfig_aaaa" {
  domain  = local.domain
  name    = format("autoconfig.%s", local.domain)
  content = "2a00:d0c0:200:0:b9:1a:9c16:5d"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_autodiscover_aaaa" {
  domain  = local.domain
  name    = format("autodiscover.%s", local.domain)
  content = "2a00:d0c0:200:0:b9:1a:9c16:5d"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_jim_aaaa" {
  domain  = local.domain
  name    = format("jim.%s", local.domain)
  content = "2a00:d0c0:200:0:b9:1a:9c:40"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_pad_aaaa" {
  domain  = local.domain
  name    = format("pad.%s", local.domain)
  content = "2a00:d0c0:200:0:c0bf:e0ff:fec1:af72"
  type    = "AAAA"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_short_aaaa" {
  domain  = local.domain
  name    = format("short.%s", local.domain)
  content = "2001:1a50:11:0:3854:d4ff:fe62:e0d8"
  type    = "AAAA"
  ttl     = 3600
}

// CNAME records

resource "inwx_nameserver_record" "twomartens_example_cdn_cname" {
  domain  = local.domain
  name    = format("cdn.%s", local.domain)
  content = "d1fvxyvcoii67h.cloudfront.net"
  type    = "CNAME"
  ttl     = 3600
}

resource "inwx_nameserver_record" "twomartens_example_aws-validations-cdn_cname" {
  domain  = local.domain
  name    = format("_4741e2d9c8a605950eebfa048029e4ef.cdn.%s", local.domain)
  content = "_cf71e85bb40cc12717f2718e4590ad23.acm-validations.aws"
  type    = "CNAME"
  ttl     = 3600
}
