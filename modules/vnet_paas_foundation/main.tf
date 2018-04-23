provider "azurerm" { }

module "monitoring" {
  source = "./monitoring"
  location = "${var.location}"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${var.monitoring_rg_name}"
  oms_retention = "${var.oms_retention}"
  tags = "${merge(var.base_tags, var.monitoring_tags)}"
}
