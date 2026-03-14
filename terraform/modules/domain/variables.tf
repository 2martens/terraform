variable "ipv4" {
  type    = string
  default = ""
}

variable "ipv6" {
  type    = string
  default = ""
}

variable "domain" {
  type = string
}

variable "subdomain" {
  type    = string
  default = ""
}

variable "hasIPRecords" {
  type    = bool
  default = true
}

variable "mxRecords" {
  type    = list(object({
    hostname: string,
    prio: number
  }))
  default = []
}

variable "txtValues" {
  type    = list(string)
  default = []
}

variable "uberspaceDomainKey" {
  type    = string
  default = ""
}
