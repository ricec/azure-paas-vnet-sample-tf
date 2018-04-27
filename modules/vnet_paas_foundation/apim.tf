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
    sslCert        = "${data.external.apim_ssl_cert.result["private_pfx"]}"
    vnetId         = "${module.networking.vnet_id}"
    subnetName     = "${module.networking.apim_subnet_name}"
    tags           = "${jsonencode(merge(var.base_tags, var.shared_app_tags))}"
  }

  provisioner "local-exec" {
    command = "${data.template_file.create_apim_diagnostic_settings.rendered}"

    environment {
      resource_id = "${azurerm_template_deployment.apim.outputs["apimId"]}"
    }
  }
}

data "template_file" "apim_diagnostic_settings" {
  template = "${file("${path.module}/diagnostics/apim_logs.json.tpl")}"

  vars {
    retention = "${var.apim_diagnostics_retention}"
  }
}

data "template_file" "create_apim_diagnostic_settings" {
  template = "${file("${path.module}/diagnostics/create_diagnostic_settings.sh.tpl")}"

  vars {
    logs_json = "${data.template_file.apim_diagnostic_settings.rendered}"
    metrics_json = ""
    storage_account_id = "${module.monitoring.diagnostics_storage_account_id}"
    oms_workspace_id = "${module.monitoring.oms_workspace_id}"
  }
}

