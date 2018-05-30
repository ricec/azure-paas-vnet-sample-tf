provider "azurerm" {}

locals {
  ops_tags          = "${merge(var.base_tags, var.ops_tags)}"
  networking_tags   = "${merge(var.base_tags, var.networking_tags)}"
  ase_base_hostname = "ase.${var.primary_hostname}"
}

resource "azurerm_resource_group" "shared_app" {
  name     = "${var.shared_app_rg_name}"
  location = "${var.primary_location}"
}

resource "azurerm_resource_group" "ops" {
  name     = "${var.ops_rg_name}"
  location = "${var.primary_location}"
  tags     = "${local.ops_tags}"
}

resource "azurerm_resource_group" "networking" {
  name     = "${var.networking_rg_name}"
  location = "${var.primary_location}"
  tags     = "${local.networking_tags}"
}

module "monitoring" {
  source              = "./monitoring"
  primary_prefix      = "${var.primary_prefix}"
  secondary_prefix    = "${var.secondary_prefix}"
  primary_location    = "${var.primary_location}"
  secondary_location  = "${var.secondary_location}"
  resource_group_name = "${azurerm_resource_group.ops.name}"
  oms_retention       = "${var.oms_retention}"
  tags                = "${local.ops_tags}"

  diagnostic_profiles = {
    apim        = 365
    key_vault   = 365
    nsg         = 365
    waf         = 365
    dev_gateway = 365
  }
}
