resource "azurerm_template_deployment" "ase" {
  name                = "ase"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/ase.json")}"

  parameters {
    aseName        = "${var.ase_name}"
    vnetId         = "${var.vnet_id}"
    subnetName     = "${var.subnet_name}"
    dnsSuffix      = "${var.dns_suffix}"
    location       = "${var.friendly_location_name}"
    tags           = "${jsonencode(var.tags)}"
  }

  deployment_mode = "Incremental"
}

resource "azurerm_template_deployment" "ase_ilb_cert" {
  name                = "ase_ilb_cert"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/ase_ilb_cert.json")}"

  parameters {
    aseName        = "${var.ase_name}"
    location       = "${var.friendly_location_name}"
    keyVaultId     = "${var.key_vault_id}"
    certSecretName = "${var.cert_secret_name}"
  }

  deployment_mode = "Incremental"
  depends_on      = ["azurerm_template_deployment.ase"]
}

data "external" "ilb_ip" {
  program = [
    "${path.module}/scripts/get_ase_ilb_ip.sh",
    "${azurerm_template_deployment.ase.outputs["aseId"]}"
  ]
}
