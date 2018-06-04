locals {
  zone_config = {
    zone_name           = "${var.zone_name}"
    resource_group_name = "${var.resource_group_name}"
    vnet_ids            = "${join(" ", var.resolution_vnet_ids)}"
  }
}

resource "null_resource" "dns" {
  triggers = "${local.zone_config}"

  provisioner "local-exec" {
    command     = "${path.module}/scripts/create_dns_private_zone.sh"
    environment = "${local.zone_config}"
  }
}
