module "ase" {
  source                       = "../app_service_environment"
  resource_group_name          = "${azurerm_resource_group.shared_app.name}"
  ase_name                     = "${module.primary_region.config["prefix"]}-ase"
  vnet_id                      = "${module.networking.vnet_id}"
  subnet_name                  = "${module.networking.ase_subnet_name}"
  dns_zone_name                = "${module.dns.zone_name}"
  dns_zone_resource_group_name = "${azurerm_resource_group.networking.name}"
  ase_subdomain                = "${module.primary_region.config["ase_subdomain"]}"
  friendly_location_name       = "${module.primary_region.config["location"]}"
  key_vault_id                 = "${azurerm_key_vault.main.id}"
  cert_secret_name             = "${module.ase_cert.cert_name}"
  tags                         = "${merge(var.base_tags, var.shared_app_tags)}"
}

module "ase_cert" {
  source = "../key_vault_certificate"
  key_vault_name = "${azurerm_key_vault.main.name}"
  cert_name = "${replace(local.ase_base_hostname, ".", "-")}"
  common_name = "*.${local.ase_base_hostname}"
  alt_names   = ["*.scm.${local.ase_base_hostname}"]
}

