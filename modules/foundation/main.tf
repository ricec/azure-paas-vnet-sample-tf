provider "azurerm" {}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "shared_app" {
  name     = "${var.shared_app_rg_name}"
  location = "${var.primary_location}"
  tags     = "${var.shared_app_tags}"
}

resource "azurerm_resource_group" "ops" {
  name     = "${var.ops_rg_name}"
  location = "${var.primary_location}"
  tags     = "${var.ops_tags}"
}

resource "azurerm_resource_group" "networking" {
  name     = "${var.networking_rg_name}"
  location = "${var.primary_location}"
  tags     = "${var.networking_tags}"
}

module "primary" {
  source          = "./region_config"
  location        = "${var.primary_location}"
  resource_prefix = "${var.resource_prefix}"
  base_hostname   = "${var.base_hostname}"
}

module "secondary" {
  source          = "./region_config"
  location        = "${var.secondary_location}"
  resource_prefix = "${var.resource_prefix}"
  base_hostname   = "${var.base_hostname}"
}

module "monitoring" {
  source              = "./monitoring"
  primary_region      = "${module.primary.config}"
  secondary_region    = "${module.secondary.config}"
  resource_group_name = "${azurerm_resource_group.ops.name}"
  oms_retention       = "${var.oms_retention}"
  tags                = "${var.ops_tags}"
}

