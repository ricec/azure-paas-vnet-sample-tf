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
  default = 365
}
