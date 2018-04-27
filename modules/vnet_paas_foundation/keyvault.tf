locals {
  apim_cert_name = "${replace(local.apim_base_hostname, ".", "-")}"
  ase_cert_name = "${replace(local.ase_base_hostname, ".", "-")}"
}

resource "azurerm_key_vault" "main" {
  name                = "${var.resource_prefix}-vault"
  location            = "${azurerm_resource_group.ops.location}"
  resource_group_name = "${azurerm_resource_group.ops.name}"
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"
  tags                = "${merge(var.base_tags, var.secrets_tags)}"

  sku {
    name = "${var.key_vault_sku}"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${var.key_vault_deployer_object_id}"

    key_permissions         = ["get"]
    secret_permissions      = ["get"]
    certificate_permissions = ["get", "create"]
  }

  # Configure diagnostic settings
  provisioner "local-exec" {
    command = "${module.monitoring.diagnostic_commands["key_vault"]}"

    environment {
      resource_id = "${azurerm_key_vault.main.id}"
    }
  }

  # Generate APIM self-signed cert
  provisioner "local-exec" {
    command = "${path.module}/scripts/generate_cert.sh"

    environment {
      cert_name   = "${local.apim_cert_name}"
      vault_name  = "${azurerm_key_vault.main.name}"
      common_name = "${local.apim_base_hostname}"
      alt_name    = "*.${local.apim_base_hostname}"
    }
  }

  # Generate ASE self-signed cert
  provisioner "local-exec" {
    command = "${path.module}/scripts/generate_cert.sh"

    environment {
      cert_name   = "${local.ase_cert_name}"
      vault_name  = "${azurerm_key_vault.main.name}"
      common_name = "*.${local.ase_base_hostname}"
      alt_name    = "*.scm.${local.ase_base_hostname}"
    }
  }
}

data "external" "apim_ssl_cert" {
  program = [
    "${path.module}/scripts/get_key_vault_certificate.sh",
    "${local.apim_cert_name}",
    "${azurerm_key_vault.main.name}"
  ]
}
