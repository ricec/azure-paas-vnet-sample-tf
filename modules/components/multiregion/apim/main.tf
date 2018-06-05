locals {
  apim_name = "${var.primary_region["prefix"]}-apim"
}

resource "azurerm_template_deployment" "apim" {
  name                = "apim-${local.apim_name}"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/apim.json")}"
  deployment_mode     = "Incremental"

  parameters {
    apimName                  = "${local.apim_name}"
    primaryLocation           = "${var.primary_region["location"]}"
    secondaryLocation         = "${var.secondary_region["location"]}"
    publisherEmail            = "${var.publisher_email}"
    publisherName             = "${var.publisher_name}"
    sku                       = "${var.sku}"
    primaryCapacity           = "${var.primary_capacity}"
    secondaryCapacity         = "${var.secondary_capacity}"
    apiHostname               = "${var.api_hostname}"
    primaryRegionalHostname   = "${var.primary_region["apim_hostname"]}"
    secondaryRegionalHostname = "${var.secondary_region["apim_hostname"]}"
    portalHostname            = "${var.portal_hostname}"
    scmHostname               = "${var.scm_hostname}"
    sslCert                   = "${var.ssl_cert}"
    primarySubnetId           = "${var.primary_subnet_id}"
    secondarySubnetId         = "${var.secondary_subnet_id}"
    tags                      = "${jsonencode(var.tags)}"
  }

  provisioner "local-exec" {
    command = "${module.apim_diagnostics.command}"

    environment {
      resource_id = "${azurerm_template_deployment.apim.outputs["apimId"]}"
    }
  }
}

module "apim_diagnostics" {
  source             = "../../diagnostic_setting"
  resource_type      = "apim"
  retention          = "${var.diagnostic_retention}"
  storage_account_id = "${var.diagnostics_storage_account_id}"
  oms_workspace_id   = "${var.oms_workspace_id}"
}

resource "azurerm_dns_a_record" "apim_primary" {
  name                = "${var.primary_region["apim_subdomain"]}"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["primaryIpAddress"]}"]
}

resource "azurerm_dns_a_record" "apim_secondary" {
  name                = "${var.secondary_region["apim_subdomain"]}"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["secondaryIpAddress"]}"]
}

resource "azurerm_dns_a_record" "apim_wildcard_primary" {
  name                = "*.${var.primary_region["apim_subdomain"]}"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["primaryIpAddress"]}"]
}

resource "azurerm_dns_a_record" "apim_wildcard_secondary" {
  name                = "*.${var.secondary_region["apim_subdomain"]}"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  ttl                 = 300
  records             = ["${azurerm_template_deployment.apim.outputs["secondaryIpAddress"]}"]
}
