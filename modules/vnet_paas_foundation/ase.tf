locals {
  ase_base_hostname = "ase.${var.base_hostname}"
}

resource "azurerm_template_deployment" "ase" {
  name                = "ase"
  resource_group_name = "${azurerm_resource_group.shared_app.name}"
  template_body       = "${file("${path.module}/ase.json")}"

  parameters {
    aseName    = "${var.resource_prefix}-ase"
    vnetId     = "${module.networking.vnet_id}"
    subnetName = "${module.networking.ase_subnet_name}"
    dnsSuffix  = "${local.ase_base_hostname}"
    location   = "${var.location}"
    tags       = "${jsonencode(merge(var.base_tags, var.shared_app_tags))}"
  }

  deployment_mode = "Incremental"
}
