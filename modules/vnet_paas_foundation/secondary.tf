module "secondary_network" {
  source                         = "./networking"
  resource_prefix                = "${var.secondary_prefix}"
  resource_group_name            = "${var.networking_rg_name}"
  location                       = "${var.secondary_location}"
  dns_zone_name                  = "${var.secondary_hostname}"
  nsg_diagnostic_retention       = "${var.diagnostic_retentions["nsg"]}"
  diagnostics_storage_account_id = "${module.monitoring.secondary_diagnostics_storage_account_id}"
  oms_workspace_id               = "${module.monitoring.oms_workspace_id}"
  tags                           = "${local.networking_tags}"
}
