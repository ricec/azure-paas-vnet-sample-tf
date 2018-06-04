locals {
  api_hostname         = "api.${var.base_hostname}"
  apim_portal_hostname = "docs.${module.primary_region.config["apim_hostname"]}"
  apim_scm_hostname    = "scm.${module.primary_region.config["apim_hostname"]}"
}

module "apim" {
  source                         = "../multiregion/apim"
  primary_region                 = "${module.primary_region.config}"
  secondary_region               = "${module.secondary_region.config}"
  resource_group_name            = "${azurerm_resource_group.shared_app.name}"
  publisher_email                = "${var.apim_publisher_email}"
  publisher_name                 = "${var.apim_publisher_name}"
  # Premium is required for both multi-region and multi-hostname configurations
  sku                            = "Premium"
  sku_count                      = "${var.apim_sku_count}"
  api_hostname                   = "${local.api_hostname}"
  portal_hostname                = "${local.apim_portal_hostname}"
  scm_hostname                   = "${local.apim_scm_hostname}"
  ssl_cert                       = "${module.apim_cert.private_pfx}"
  vnet_id                        = "${module.networking.vnet_id}"
  subnet_name                    = "${module.networking.apim_subnet_name}"
  dns_zone_name                  = "${module.dns.zone_name}"
  dns_zone_resource_group_name   = "${azurerm_resource_group.networking.name}"
  diagnostic_retention           = "${var.diagnostic_retentions["apim"]}"
  diagnostics_storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id               = "${module.monitoring.oms_workspace_id}"
  tags                           = "${merge(var.base_tags, var.shared_app_tags)}"
}

module "apim_cert" {
  source         = "../key_vault_certificate"
  key_vault_name = "${azurerm_key_vault.main.name}"
  cert_name      = "${replace(local.api_hostname, ".", "-")}"
  common_name    = "${local.api_hostname}"
  alt_names      = [
    "${module.primary_region.config["apim_hostname"]}",
    "*.${module.primary_region.config["apim_hostname"]}",
    "${module.secondary_region.config["apim_hostname"]}",
    "*.${module.secondary_region.config["apim_hostname"]}"
  ]
}
