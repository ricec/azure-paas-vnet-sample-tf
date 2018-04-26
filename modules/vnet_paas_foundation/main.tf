provider "azurerm" {}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "shared_app" {
  name     = "${var.shared_app_rg_name}"
  location = "${var.location}"
}

resource "azurerm_resource_group" "ops" {
  name     = "${var.ops_rg_name}"
  location = "${var.location}"
}

module "monitoring" {
  source = "./monitoring"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${azurerm_resource_group.ops.name}"
  oms_retention = "${var.oms_retention}"
  tags = "${merge(var.base_tags, var.monitoring_tags)}"
}

module "networking" {
  source = "./networking"
  location = "${var.location}"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${var.networking_rg_name}"
  dns_servers = "${var.dns_servers}"
  nsg_diagnostics_retention = "${var.nsg_diagnostics_retention}"
  waf_diagnostics_retention = "${var.waf_diagnostics_retention}"
  dev_gateway_diagnostics_retention = "${var.dev_gateway_diagnostics_retention}"
  diagnostics_storage_account_id = "${module.monitoring.diagnostics_storage_account_id}"
  oms_workspace_id = "${module.monitoring.oms_workspace_id}"
  tags = "${merge(var.base_tags, var.networking_tags)}"
}
