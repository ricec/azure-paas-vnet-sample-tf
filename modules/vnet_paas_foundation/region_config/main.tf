variable "location" {}
variable "resource_prefix" {}
variable "base_hostname" {}

locals {
  affix           = "${lower(replace(var.location, "/[a-z ]/", ""))}"
  prefix          = "${var.resource_prefix}-${local.affix}"
  alphanum_prefix = "${replace(local.prefix, "/[^a-zA-Z0-9]/", "")}"
  ase_subdomain   = "ase.${local.affix}"
  apim_subdomain  = "api.${local.affix}"
}

output "config" {
  value = {
    location        = "${var.location}"
    prefix          = "${local.prefix}"
    alphanum_prefix = "${local.alphanum_prefix}"
    hostname        = "${local.affix}.${var.base_hostname}"
    ase_subdomain   = "${local.ase_subdomain}"
    apim_subdomain  = "${local.apim_subdomain}"
    ase_hostname    = "${local.ase_subdomain}.${var.base_hostname}"
    apim_hostname   = "${local.apim_subdomain}.${var.base_hostname}"
  }
}
