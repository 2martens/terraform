// Identity management
module "keycloak_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "id"
  ipv4      = "95.143.172.184"
  ipv6      = "2001:1a50:11:0:98b3:92ff:fe3e:bba1"
  mxRecords = [{
    hostname : "monoceres.uberspace.de"
    prio : 0
  }]
  txtValues          = ["v=spf1 include:spf.uberspace.de ~all"]
  uberspaceDomainKey = "v=DKIM1;t=s;n=core;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqs3bFL8W77z7VJHCFbsJ3o68Y1uBbVsbIS1y35CMfRv6wp7si7aIG2ZeKqzdh2dTMsvtvSMaYVq1gT/EtRmTbU/BYC21ff8sqcVqn/ll5nNsk5jKWXTYAlTQp4LBQN7icw94ZNGr5/SDYcnv2nsBYFf2GUviObWXGHX4RaBFNj9NVUNWNin/HicvW+LsbfYq37QtlhjmUn9K96VCwKcTV1mx+Ek0osErYefcOVNawqWIlVRQDLkHZhk1StLsOpRqV+qEjhzTk4n4ZiNtLJG1D9CpHl24d5DKsQDyVFdEfqHimFTSNgiitlkuXg+i+NMiRA9G3gNJtvw8uvfN8f+stQIDAQAB"
}

// Angular frontends
# module "wahlrecht_domain" {
#   source    = "./modules/domain"
#   domain    = local.domain
#   subdomain = "wahlrecht"
#   ipv4      = "185.26.156.43"
#   ipv6      = "2a00:d0c0:200:0:470:9fff:fe83:16bc"
# }

// CI/CD
module "gitea_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "git"
  ipv4      = "185.26.156.91"
  ipv6      = "2a00:d0c0:200:0:b9:1a:9c:5a"
}

module "helm-repo_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "repo"
  ipv4      = "185.26.156.49"
  ipv6      = "2a00:d0c0:200:0:2ca6:bff:fe78:832f"
}

// Monitoring
module "statping_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "status"
  ipv4      = "185.26.156.33"
  ipv6      = "2a00:d0c0:200:0:f8e2:6fff:fec2:7a92"
}

// Personal Website
module "personal_website_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = ""
  ipv4      = "185.26.156.65"
  ipv6      = "2a00:d0c0:200:0:b9:1a:9c:40"
  mxRecords = [{
    hostname : "howell.uberspace.de"
    prio : 0
  }]
  txtValues = [
    "openai-domain-verification=dv-EcR0SCNAnUYVquVZVgb21Wdt",
    "google-site-verification=nUFiHQFxBpBMdX96ELH3TcfyIfXf2ZlwMFYtXjVq5lo",
    "v=spf1 include:_spf.protonmail.ch include:spf.uberspace.de ~all",
    "protonmail-verification=7826a94332156f5f99864093635e7fe0af47487f"
  ]
  uberspaceDomainKey = "v=DKIM1;t=s;n=core;p=MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA3inJYRQRdWD0NQf9WRVcct8Z+GF74WYCK9Q9E/hl9qRSrqHLbm4AZ8gDWZDUQ7O0WbsQ4wcBa2SLB0znpW2UmVrp0iMhqGXVU5USWTHLgAPOVo9DKKbY5wCuugftQe99hvW1Z5BNhzvGUczknQHW/oZF/a7l1nwkYuAZ9YyzQY+sB8o3euuZ0QxaVde0UNDMGpjUO/Nd8MRZj1WBNNyy12ppKVskg7GzuVpulkskslM/mAWdTJ7HKZh1HHPjjGS2ttyDMGWU7/sxuenZ5Z46PvKWQ37djwEsXqXuqYrLI+QBoefolhisHNhHA9cwuUU3bq/+zXhLTN4bYZVPeV31mM6cguKJibPXg0HgYUImJ0A/sADYcd4q7ryZ/sAzCydPT4FDrx64apRPlaIhugSU1KCz+N+7UtCjrQaJLA8i/F4+krfZpfiYr5MJrI8jTAZFW9lzGL7NTVLe1yDf/9aJGc7R/TyI/c5uGFGUnu0C+AKC5KJCIf/I2hJ9ARRRzKe1RtmiTJMAxi8FqzRQoEQwfSDi+vGXtrUC4JCV2Zh7xgwmZV+lMiP5M6x3aOM7FI26WPx+7tdRlzWiYu7okS5ayAgu26EYoKjGuWWHGUuKSKNqjTy3oBunZv3LzdnhOAn4eOrE7+2qn8hiL8SLa9oGcUv1BI0KQmopIAY+BiaX6JkCAwEAAQ=="
}

// Nextcloud
# module "nextcloud_domain" {
#   source      = "./modules/domain"
#   domain      = local.domain
#   subdomain   = "cloud"
#   ipv4        = "185.26.156.194"
#   ipv6        = "2a00:d0c0:200:0:b9:1a:9c:95"
#   hasMXRecord = true
#   hostName    = "kushida.uberspace.de"
#   mxPrio      = 0
#   mxSpf       = "v=spf1 include:spf.uberspace.de ~all"
# }

// App Review (Mail only)
module "appreview_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "appreview"

  hasIPRecords = false
  mxRecords = [{
    hostname : "wolf.uberspace.de"
    prio : 0
  }]
  txtValues = [
    "v=spf1 include:spf.uberspace.de ~all"
  ]
  uberspaceDomainKey = "v=DKIM1;t=s;n=core;p=MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAuzbMYDHwmAtKti6DFFZu7ySxbWE87XgA14OPck78rj4QX3cNFdnn+WkUpmp0x76NN1rhm3EKCcbBUs9I6MvFQU7A9QJFpMoGq+u7OJ63SSDSmnzUld0mKnWbj/gNp1r4ChQB5JSFIT2A6Q3ias6IM1DscBqfsGsp6StbWaIiBF7Mro7p64sHX4kUgW1iBtNiix0GHqi6imzAryOiGg+X3GhjhwV0j+15rBeBSaFOX2TudlE5VHLox59TLb8ctfdir3kT7UFWJT2GW1iWgUxaTxU6OsSLe2vuQcXIYFBcTN2lbw/dXp7LdBPFzXygC9LZsjxao2bxwAs5MpCLpMrFZVbCEDSO9fEiSsGqgBcwiyxG0DnHexGbKMpr2Ergt+Q9NhfzUjcfNzGvG0HaPEIM70J+yK8gi4mGT7hTRjAFL9+8hGW8qjvna89WAu/ACKSGw3sKIqtevO4Cpc2FMZ1v0FmW7eshe++qfe7lodCmUeaZnQD9H6iR+Q4UJm4QBjIB3uz6ZiXMSZdhfc14T493o14V0j/IAu/OngeZM4O24XR8xCj0NvNAObh6OlKKEIv0fyPlauhQnz573K8fhsPeAFxNnc5lDRTRL96FJFIy3tefDJVHFr5yaFzxQPtaf17mBIaLqKOj42YkZmgcd7+1kN/G8HvrhzsCuz+Zr6z12rcCAwEAAQ=="
}

// Payload CMS
module "cms_domain" {
  source    = "./modules/domain"
  domain    = hcloud_zone.twomartens_de.name
  subdomain = "cms"
  ipv4      = "95.143.172.212"
  ipv6      = "2001:1a50:11:0:247a:8ff:fe00:5f6c"
}
