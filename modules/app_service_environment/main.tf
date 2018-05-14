resource "azurerm_template_deployment" "ase" {
  name                = "ase"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/ase.json")}"

  parameters {
    aseName    = "${var.ase_name}"
    vnetId     = "${var.vnet_id}"
    subnetName = "${var.subnet_name}"
    dnsSuffix  = "${var.dns_suffix}"
    location   = "${var.friendly_location_name}"
    tags       = "${jsonencode(var.tags)}"
  }

  deployment_mode = "Incremental"
}
