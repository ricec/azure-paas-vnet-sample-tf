locals {
  apim_base_hostname = "api.${var.base_hostname}"
}

resource "azurerm_template_deployment" "apim" {
  name                = "apim"
  resource_group_name = "${azurerm_resource_group.shared_app.name}"
  template_body       = "${file("${path.module}/apim.json")}"
  deployment_mode = "Incremental"

  parameters {
    apimName       = "${var.resource_prefix}-apim"
    publisherEmail = "${var.apim_publisher_email}"
    publisherName  = "${var.apim_publisher_name}"
    sku            = "${var.apim_sku}"
    skuCount       = "${var.apim_sku_count}"
    proxyHostname  = "${local.apim_base_hostname}"
    portalHostname = "docs.${local.apim_base_hostname}"
    scmHostname    = "scm.${local.apim_base_hostname}"
    sslCert        = "${module.secrets.apim_cert["private_pfx"]}"
    vnetId         = "${module.networking.vnet_id}"
    subnetName     = "${module.networking.apim_subnet_name}"
    tags           = "${jsonencode(merge(var.base_tags, var.shared_app_tags))}"
  }

  provisioner "local-exec" {
    command = "${module.monitoring.diagnostic_commands["apim"]}"

    environment {
      resource_id = "${azurerm_template_deployment.apim.outputs["apimId"]}"
    }
  }
}
