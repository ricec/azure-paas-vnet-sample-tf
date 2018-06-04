locals {
  cert_config = {
    vault_name  = "${var.key_vault_name}"
    cert_name   = "${var.cert_name}"
    common_name = "${var.common_name}"
    alt_names   = "${jsonencode(var.alt_names)}"
  }
}

resource "null_resource" "cert" {
  triggers = "${local.cert_config}"

  provisioner "local-exec" {
    command     = "${path.module}/scripts/generate_cert.sh"
    environment = "${local.cert_config}"
  }
}

data "external" "cert" {
  program = [
    "${path.module}/scripts/get_key_vault_certificate.sh",
    "${null_resource.cert.triggers["cert_name"]}",
    "${null_resource.cert.triggers["vault_name"]}"
  ]
}
