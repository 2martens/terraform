variable "domain" {
  type = string
}

variable "subdomain" {
  type    = string
  default = ""
}

variable "cname_target" {
  type = string
}

variable "validation_key" {
  type = string
}

variable "validation_target" {
  type = string
}
