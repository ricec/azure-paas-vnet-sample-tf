resource "azurerm_template_deployment" "ase" {
  name                = "ase"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/ase.json")}"

  parameters {
    aseName        = "${var.ase_name}"
    vnetId         = "${var.vnet_id}"
    subnetName     = "${var.subnet_name}"
    dnsSuffix      = "${var.ase_subdomain}.${var.dns_zone_name}"
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

resource "azurerm_dns_a_record" "ase_wildcard" {
  name                = "*.${var.ase_subdomain}"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  ttl                 = 300
  records             = ["${data.external.ilb_ip.result["ilb_ip"]}"]
}

resource "azurerm_dns_a_record" "ase_scm_wildcard" {
  name                = "*.scm.${var.ase_subdomain}"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  ttl                 = 300
  records             = ["${data.external.ilb_ip.result["ilb_ip"]}"]
}
