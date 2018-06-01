module "secondary_network" {
  source                         = "./networking"
  resource_prefix                = "${module.secondary_region.config["prefix"]}"
  resource_group_name            = "${var.networking_rg_name}"
  location                       = "${module.secondary_region.config["location"]}"
  dns_zone_name                  = "${module.secondary_region.config["hostname"]}"
  nsg_diagnostic_retention       = "${var.diagnostic_retentions["nsg"]}"
  diagnostics_storage_account_id = "${module.monitoring.secondary_diagnostics_storage_account_id}"
  oms_workspace_id               = "${module.monitoring.oms_workspace_id}"
  tags                           = "${local.networking_tags}"
}
