locals {
  api_hostname            = "api.${var.base_hostname}"
  apim_primary_hostname   = "api.${module.primary_region.config["hostname"]}"
  apim_secondary_hostname = "api.${module.secondary_region.config["hostname"]}"
  apim_portal_hostname    = "docs.${module.primary_region.config["apim_hostname"]}"
  apim_scm_hostname       = "scm.${module.primary_region.config["apim_hostname"]}"
}

resource "azurerm_template_deployment" "apim" {
  name                = "apim"
  resource_group_name = "${azurerm_resource_group.shared_app.name}"
  template_body       = "${file("${path.module}/apim.json")}"
  deployment_mode     = "Incremental"

  parameters {
    apimName                  = "${module.primary_region.config["prefix"]}-apim"
    publisherEmail            = "${var.apim_publisher_email}"
    publisherName             = "${var.apim_publisher_name}"
    # Premium is required for both multi-region and multi-hostname configurations
    sku                       = "Premium"
    skuCount                  = "${var.apim_sku_count}"
    apiHostname               = "${local.api_hostname}"
    primaryRegionalHostname   = "${local.apim_primary_hostname}"
    secondaryRegionalHostname = "${local.apim_secondary_hostname}"
    portalHostname            = "${local.apim_portal_hostname}"
    scmHostname               = "${local.apim_scm_hostname}"
    sslCert                   = "${module.apim_cert.private_pfx}"
    vnetId                    = "${module.networking.vnet_id}"
    subnetName                = "${module.networking.apim_subnet_name}"
    tags                      = "${jsonencode(merge(var.base_tags, var.shared_app_tags))}"
  }

  provisioner "local-exec" {
    command = "${module.apim_diagnostics.command}"

    environment {
      resource_id = "${azurerm_template_deployment.apim.outputs["apimId"]}"
    }
  }
}

module "apim_diagnostics" {
  source             = "../diagnostic_setting"
  resource_type      = "apim"
  retention          = "${var.diagnostic_retentions["apim"]}"
  storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id   = "${module.monitoring.oms_workspace_id}"
}

module "apim_cert" {
  source         = "../key_vault_certificate"
  key_vault_name = "${azurerm_key_vault.main.name}"
  cert_name      = "${replace(local.api_hostname, ".", "-")}"
  common_name    = "${local.api_hostname}"
  alt_names      = [
    "${local.apim_primary_hostname}",
    "*.${local.apim_primary_hostname}",
    "${local.apim_secondary_hostname}",
    "*.${local.apim_secondary_hostname}"
  ]
}

resource "azurerm_dns_a_record" "apim" {
  name                = "${module.primary_region.config["apim_subdomain"]}"
  zone_name           = "${module.dns.zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["ipAddress"]}"]
}

resource "azurerm_dns_a_record" "apim_wildcard" {
  name                = "*.${module.primary_region.config["apim_subdomain"]}"
  zone_name           = "${module.dns.zone_name}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["ipAddress"]}"]
}
