module "secrets" {
  source                         = "./secrets"
  resource_prefix                = "${var.primary_prefix}"
  resource_group_name            = "${azurerm_resource_group.ops.name}"
  key_vault_sku                  = "${var.key_vault_sku}"
  key_vault_deployer_object_id   = "${var.key_vault_deployer_object_id}"
  key_vault_diagnostic_retention = "${var.diagnostic_retentions["key_vault"]}"
  diagnostics_storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id               = "${module.monitoring.oms_workspace_id}"
  tags                           = "${local.ops_tags}"

  apim_cert_config = {
    cert_name   = "${replace(local.apim_base_hostname, ".", "-")}"
    common_name = "${local.apim_base_hostname}"
    alt_name    = "*.${local.apim_base_hostname}"
  }

  ase_cert_config = {
    cert_name   = "${replace(local.ase_base_hostname, ".", "-")}"
    common_name = "*.${local.ase_base_hostname}"
    alt_name    = "*.scm.${local.ase_base_hostname}"
  }
}

module "networking" {
  source                         = "./networking"
  resource_prefix                = "${var.primary_prefix}"
  resource_group_name            = "${var.networking_rg_name}"
  location                       = "${var.primary_location}"
  dns_zone_name                  = "${var.primary_hostname}"
  nsg_diagnostic_retention       = "${var.diagnostic_retentions["nsg"]}"
  diagnostics_storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id               = "${module.monitoring.oms_workspace_id}"
  tags                           = "${local.networking_tags}"
}

module "ase" {
  source                 = "../app_service_environment"
  resource_group_name    = "${azurerm_resource_group.shared_app.name}"
  ase_name               = "${var.primary_prefix}-ase"
  vnet_id                = "${module.networking.vnet_id}"
  subnet_name            = "${module.networking.ase_subnet_name}"
  dns_suffix             = "${local.ase_base_hostname}"
  friendly_location_name = "${var.primary_location}"
  key_vault_id           = "${module.secrets.key_vault_id}"
  cert_secret_name       = "${module.secrets.ase_cert_secret_name}"
  tags                   = "${merge(var.base_tags, var.shared_app_tags)}"
}

resource "azurerm_dns_a_record" "ase" {
  name                = "*.ase"
  zone_name           = "${module.networking.dns_zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${module.ase.ilb_ip}"]
}

resource "azurerm_dns_a_record" "ase_scm" {
  name                = "*.scm.ase"
  zone_name           = "${module.networking.dns_zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${module.ase.ilb_ip}"]
}
