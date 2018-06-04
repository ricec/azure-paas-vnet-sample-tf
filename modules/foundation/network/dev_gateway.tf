resource "azurerm_public_ip" "dev_gateway" {
  name                         = "${var.region["prefix"]}-dev-gateway-ip"
  location                     = "${var.region["location"]}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "dynamic"
  tags                         = "${var.tags}"
}

# This Application Gateway is being deployed as an ARM template because
# Terraform doesn't currently support custom status code match conditions in
# probes.
resource "azurerm_template_deployment" "dev_gateway" {
  name                = "dev_gateway"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/dev_gateway.json")}"
  deployment_mode     = "Incremental"

  parameters {
    gatewayName         = "${var.region["prefix"]}-dev-gateway"
    skuName             = "${var.dev_gateway_sku}"
    capacity            = "${var.dev_gateway_capacity}"
    location            = "${var.region["location"]}"
    apimSslCert         = "${var.apim_private_pfx}"
    apimSslPublicKey    = "${var.apim_public_cer}"
    apimHostname        = "${var.region["apim_hostname"]}"
    apimProbeHostname   = "${var.region["apim_hostname"]}"
    apimScmHostname     = "${var.apim_scm_hostname}"
    apimPortalHostname  = "${var.apim_portal_hostname}"
    aseSslCert          = "${var.ase_private_pfx}"
    aseSslPublicKey     = "${var.ase_public_cer}"
    aseHostname         = "fake.${var.region["ase_hostname"]}"
    service1ScmHostname = "${var.service_1_name}.scm.${var.region["ase_hostname"]}"
    vnetId              = "${azurerm_virtual_network.main.id}"
    subnetName          = "${azurerm_subnet.dev_gateway.name}"
    publicIpId          = "${azurerm_public_ip.dev_gateway.id}"
    tags                = "${jsonencode(var.tags)}"
  }

  provisioner "local-exec" {
    command = "${module.app_gateway_diagnostics.command}"

    environment {
      resource_id = "${azurerm_template_deployment.dev_gateway.outputs["gatewayId"]}"
    }
  }
}
