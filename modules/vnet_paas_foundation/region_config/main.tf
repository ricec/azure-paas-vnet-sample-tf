variable "location" {}
variable "resource_prefix" {}
variable "base_hostname" {}

locals {
  affix           = "${lower(replace(var.location, "/[a-z ]/", ""))}"
  prefix          = "${var.resource_prefix}-${local.affix}"
  alphanum_prefix = "${replace(local.prefix, "/[^a-zA-Z0-9]/", "")}"
  hostname        = "${local.affix}.${var.base_hostname}"
}

output "config" {
  value = {
    location        = "${var.location}"
    prefix          = "${local.prefix}"
    alphanum_prefix = "${local.alphanum_prefix}"
    hostname        = "${local.hostname}"
    ase_hostname    = "ase.${local.hostname}"
    apim_hostname   = "api.${local.hostname}"
  }
}
