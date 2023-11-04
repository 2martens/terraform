resource "inwx_nameserver_record" "argocd_a" {
  domain  = var.domain
  name    = format("%s.%s", "argocd", local.kube_api_server_domain)
  content = inwx_nameserver_record.kube_api_server_a.content
  type    = "A"
  ttl     = 3600
}
resource "inwx_nameserver_record" "argocd_aaaa" {
  domain  = var.domain
  name    = format("%s.%s", "argocd", local.kube_api_server_domain)
  content = inwx_nameserver_record.kube_api_server_aaaa.content
  type    = "AAAA"
  ttl     = 3600
}
