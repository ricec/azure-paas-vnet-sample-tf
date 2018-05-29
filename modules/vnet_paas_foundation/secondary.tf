module "secondary_network" {
  source              = "./networking"
  resource_prefix     = "${var.secondary_prefix}"
  resource_group_name = "${var.networking_rg_name}"
  location            = "${var.secondary_location}"
  dns_zone_name       = "${var.secondary_hostname}"
  diagnostic_commands = "${module.monitoring.diagnostic_commands}"
  tags                = "${local.networking_tags}"
}
