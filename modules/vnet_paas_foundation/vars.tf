variable "location" {}
variable "resource_prefix" {}
variable "base_tags" {
  default = {}
}


variable "monitoring_rg_name" {}
variable "monitoring_tags" {
  default = {
    Tier = "Ops"
  }
}

variable "oms_retention" {
  default = 30
}


variable "networking_rg_name" {}
variable "networking_tags" {
  default = {
    Tier = "Networking"
  }
}

variable "dns_servers" {
  default = []
}

variable "nsg_diagnostics_retention" {
  default = 365
}

variable "waf_diagnostics_retention" {
  default = 365
}

variable "dev_gateway_diagnostics_retention" {
  default = 365
}
