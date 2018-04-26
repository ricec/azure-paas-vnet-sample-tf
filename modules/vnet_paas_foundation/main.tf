provider "azurerm" { }

module "monitoring" {
  source = "./monitoring"
  location = "${var.location}"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${var.monitoring_rg_name}"
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
