module "secrets" {
  source                         = "./secrets"
  resource_prefix                = "${module.primary_region.config["prefix"]}"
  resource_group_name            = "${azurerm_resource_group.ops.name}"
  key_vault_sku                  = "${var.key_vault_sku}"
  key_vault_deployer_object_id   = "${var.key_vault_deployer_object_id}"
  key_vault_diagnostic_retention = "${var.diagnostic_retentions["key_vault"]}"
  diagnostics_storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id               = "${module.monitoring.oms_workspace_id}"
  tags                           = "${local.ops_tags}"
}

module "networking" {
  source                         = "./networking"
  region                         = "${module.primary_region.config}"
  resource_group_name            = "${var.networking_rg_name}"
  waf_sku                        = "${var.waf_sku}"
  waf_capacity                   = "${var.waf_capacity}"
  dev_gateway_sku                = "${var.dev_gateway_sku}"
  dev_gateway_capacity           = "${var.dev_gateway_capacity}"
  apim_scm_hostname              = "${local.apim_scm_hostname}"
  apim_portal_hostname           = "${local.apim_portal_hostname}"
  apim_private_pfx               = "${module.apim_cert.private_pfx}"
  apim_public_cer                = "${module.apim_cert.public_cer}"
  ase_private_pfx                = "${module.ase_cert.private_pfx}"
  ase_public_cer                 = "${module.ase_cert.public_cer}"
  service_1_name                 = "${var.service_1_name}"
  diagnostic_retentions          = "${var.diagnostic_retentions}"
  diagnostics_storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id               = "${module.monitoring.oms_workspace_id}"
  tags                           = "${local.networking_tags}"
}

module "ase" {
  source                 = "../app_service_environment"
  resource_group_name    = "${azurerm_resource_group.shared_app.name}"
  ase_name               = "${module.primary_region.config["prefix"]}-ase"
  vnet_id                = "${module.networking.vnet_id}"
  subnet_name            = "${module.networking.ase_subnet_name}"
  dns_suffix             = "${local.ase_base_hostname}"
  friendly_location_name = "${module.primary_region.config["location"]}"
  key_vault_id           = "${module.secrets.key_vault_id}"
  cert_secret_name       = "${module.ase_cert.cert_name}"
  tags                   = "${merge(var.base_tags, var.shared_app_tags)}"
}

module "ase_cert" {
  source = "../key_vault_certificate"
  key_vault_name = "${module.secrets.key_vault_name}"
  cert_name = "${replace(local.ase_base_hostname, ".", "-")}"
  common_name = "*.${local.ase_base_hostname}"
  alt_names   = ["*.scm.${local.ase_base_hostname}"]
}

resource "azurerm_dns_a_record" "ase_wildcard" {
  name                = "*.ase"
  zone_name           = "${module.networking.dns_zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${module.ase.ilb_ip}"]
}

resource "azurerm_dns_a_record" "ase_scm_wildcard" {
  name                = "*.scm.ase"
  zone_name           = "${module.networking.dns_zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${module.ase.ilb_ip}"]
}

resource "azurerm_dns_a_record" "apim" {
  name                = "api"
  zone_name           = "${module.networking.dns_zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["ipAddress"]}"]
}

resource "azurerm_dns_a_record" "apim_wildcard" {
  name                = "*.api"
  zone_name           = "${module.networking.dns_zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["ipAddress"]}"]
}
