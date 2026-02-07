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

variable "hasMXRecord" {
  type    = bool
  default = false
}

variable "hasIPRecords" {
  type    = bool
  default = true
}

variable "hostName" {
  type    = string
  default = ""
}

variable "mxPrio" {
  type    = number
  default = 0
}

variable "txtValues" {
  type    = list(string)
  default = []
}

variable "uberspaceDomainKey" {
  type    = string
  default = ""
}
