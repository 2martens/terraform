variable "ipv4" {
  type = string
}

variable "ipv6" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "hasMXRecord" {
  type    = bool
  default = false
}

variable "hostName" {
  type    = string
  default = ""
}

variable "mxPrio" {
  type    = number
  default = 0
}

variable "mxSpf" {
  type    = string
  default = ""
}