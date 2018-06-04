locals {
  ase_base_hostname = "${module.primary.config["ase_hostname"]}"
}

module "primary_ase" {
  source                       = "../components/app_service_environment"
  resource_group_name          = "${azurerm_resource_group.shared_app.name}"
  ase_name                     = "${module.primary.config["prefix"]}-ase"
  vnet_id                      = "${module.primary_network.vnet_id}"
  subnet_name                  = "${module.primary_network.ase_subnet_name}"
  dns_zone_name                = "${module.dns.zone_name}"
  dns_zone_resource_group_name = "${azurerm_resource_group.networking.name}"
  ase_subdomain                = "${module.primary.config["ase_subdomain"]}"
  friendly_location_name       = "${module.primary.config["location"]}"
  key_vault_id                 = "${azurerm_key_vault.main.id}"
  cert_secret_name             = "${module.ase_cert.cert_name}"
  tags                         = "${local.shared_app_tags}"
}

module "secondary_ase" {
  source                       = "../components/app_service_environment"
  resource_group_name          = "${azurerm_resource_group.shared_app.name}"
  ase_name                     = "${module.secondary.config["prefix"]}-ase"
  vnet_id                      = "${module.secondary_network.vnet_id}"
  subnet_name                  = "${module.secondary_network.ase_subnet_name}"
  dns_zone_name                = "${module.dns.zone_name}"
  dns_zone_resource_group_name = "${azurerm_resource_group.networking.name}"
  ase_subdomain                = "${module.secondary.config["ase_subdomain"]}"
  friendly_location_name       = "${module.secondary.config["location"]}"
  key_vault_id                 = "${azurerm_key_vault.main.id}"
  cert_secret_name             = "${module.ase_cert.cert_name}"
  tags                         = "${local.shared_app_tags}"
}

module "ase_cert" {
  source = "../components/key_vault_certificate"
  key_vault_name = "${azurerm_key_vault.main.name}"
  cert_name = "${replace(local.ase_base_hostname, ".", "-")}"
  common_name = "*.${local.ase_base_hostname}"
  alt_names   = ["*.scm.${local.ase_base_hostname}"]
}

