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
    command = "${data.template_file.create_key_vault_diagnostic_settings.rendered}"

    environment {
      resource_id = "${azurerm_key_vault.main.id}"
    }
  }

  # Generate APIM self-signed cert
  provisioner "local-exec" {
    command = "${path.module}/scripts/generate_cert.sh"

    environment {
      cert_name   = "${replace(local.apim_base_hostname, ".", "-")}"
      vault_name  = "${azurerm_key_vault.main.name}"
      common_name = "${local.apim_base_hostname}"
      alt_name    = "*.${local.apim_base_hostname}"
    }
  }

  # Generate ASE self-signed cert
  provisioner "local-exec" {
    command = "${path.module}/scripts/generate_cert.sh"

    environment {
      cert_name   = "${replace(local.ase_base_hostname, ".", "-")}"
      vault_name  = "${azurerm_key_vault.main.name}"
      common_name = "*.${local.ase_base_hostname}"
      alt_name    = "*.scm.${local.ase_base_hostname}"
    }
  }
}

data "template_file" "key_vault_diagnostic_logs_settings" {
  template = "${file("${path.module}/diagnostics/key_vault_logs.json.tpl")}"

  vars {
    retention = "${var.key_vault_diagnostics_retention}"
  }
}

data "template_file" "key_vault_diagnostic_metrics_settings" {
  template = "${file("${path.module}/diagnostics/key_vault_metrics.json.tpl")}"

  vars {
    retention = "${var.key_vault_diagnostics_retention}"
  }
}

data "template_file" "create_key_vault_diagnostic_settings" {
  template = "${file("${path.module}/diagnostics/create_diagnostic_settings.sh.tpl")}"

  vars {
    logs_json          = "${data.template_file.key_vault_diagnostic_logs_settings.rendered}"
    metrics_json       = "${data.template_file.key_vault_diagnostic_metrics_settings.rendered}"
    storage_account_id = "${module.monitoring.diagnostics_storage_account_id}"
    oms_workspace_id   = "${module.monitoring.oms_workspace_id}"
  }
}


