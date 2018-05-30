resource "azurerm_public_ip" "dev_gateway" {
  name                         = "${var.primary_prefix}-dev-gateway-ip"
  location                     = "${var.primary_location}"
  resource_group_name          = "${azurerm_resource_group.networking.name}"
  public_ip_address_allocation = "dynamic"
  tags                         = "${local.networking_tags}"
}

# This Application Gateway is being deployed as an ARM template because
# Terraform doesn't currently support custom status code match conditions in
# probes.
resource "azurerm_template_deployment" "dev_gateway" {
  name                = "dev_gateway"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  template_body       = "${file("${path.module}/dev_gateway.json")}"
  deployment_mode     = "Incremental"

  parameters {
    gatewayName         = "${var.primary_prefix}-dev-gateway"
    skuName             = "${var.dev_gateway_sku}"
    capacity            = "${var.dev_gateway_capacity}"
    apimSslCert         = "${module.secrets.apim_cert["private_pfx"]}"
    apimSslPublicKey    = "${module.secrets.apim_cert["public_cer"]}"
    apimId              = "${azurerm_template_deployment.apim.outputs["apimId"]}"
    apimProbeHostname   = "${local.apim_base_hostname}"
    apimScmHostname     = "${local.apim_scm_hostname}"
    apimPortalHostname  = "${local.apim_portal_hostname}"
    aseSslCert          = "${module.secrets.ase_cert["private_pfx"]}"
    aseSslPublicKey     = "${module.secrets.ase_cert["public_cer"]}"
    aseIpAddress        = "${module.ase.ilb_ip}"
    service1ScmHostname = "${var.service_1_name}.scm.${local.ase_base_hostname}"
    vnetId              = "${module.networking.vnet_id}"
    subnetName          = "${module.networking.dev_gateway_subnet_name}"
    publicIpId          = "${azurerm_public_ip.dev_gateway.id}"
    tags                = "${jsonencode(local.networking_tags)}"
  }

  provisioner "local-exec" {
    command = "${module.app_gateway_diagnostics.command}"

    environment {
      resource_id = "${azurerm_template_deployment.dev_gateway.outputs["gatewayId"]}"
    }
  }
}
