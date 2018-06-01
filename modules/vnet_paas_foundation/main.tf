provider "azurerm" {}

locals {
  ops_tags          = "${merge(var.base_tags, var.ops_tags)}"
  networking_tags   = "${merge(var.base_tags, var.networking_tags)}"
  ase_base_hostname = "ase.${module.primary_region.config["hostname"]}"
}

module "primary_region" {
  source          = "./region_config"
  location        = "${var.primary_location}"
  resource_prefix = "${var.resource_prefix}"
  base_hostname   = "${var.base_hostname}"
}

module "secondary_region" {
  source          = "./region_config"
  location        = "${var.secondary_location}"
  resource_prefix = "${var.resource_prefix}"
  base_hostname   = "${var.base_hostname}"
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
  primary_region      = "${module.primary_region.config}"
  secondary_region    = "${module.secondary_region.config}"
  resource_group_name = "${azurerm_resource_group.ops.name}"
  oms_retention       = "${var.oms_retention}"
  tags                = "${local.ops_tags}"
}

module "apim_diagnostics" {
  source             = "../diagnostic_setting"
  resource_type      = "apim"
  retention          = "${var.diagnostic_retentions["app_gateway"]}"
  storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id   = "${module.monitoring.oms_workspace_id}"
}

module "app_gateway_diagnostics" {
  source             = "../diagnostic_setting"
  resource_type      = "app_gateway"
  retention          = "${var.diagnostic_retentions["app_gateway"]}"
  storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id   = "${module.monitoring.oms_workspace_id}"
}
