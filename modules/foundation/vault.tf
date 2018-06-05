resource "azurerm_key_vault" "main" {
  name                = "${module.primary.config["prefix"]}-vault"
  location            = "${module.primary.config["location"]}"
  resource_group_name = "${azurerm_resource_group.ops.name}"
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"
  tags                = "${var.ops_tags}"

  sku {
    name = "${var.key_vault_sku}"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${var.key_vault_deployer_object_id}"

    key_permissions         = ["get"]
    secret_permissions      = ["get"]
    certificate_permissions = ["get", "list", "create"]
  }

  # Grants Microsoft.Azure.WebSites access to read secrets.
  # This is used to create the ASE's certificate from the Key Vault cert.
  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "f8daea97-62e7-4026-becf-13c2ea98e8b4"

    key_permissions         = []
    secret_permissions      = ["get"]
    certificate_permissions = []
  }

  # Configure diagnostic settings
  provisioner "local-exec" {
    command = "${module.key_vault_diagnostics.command}"

    environment {
      resource_id = "${azurerm_key_vault.main.id}"
    }
  }
}

module "key_vault_diagnostics" {
  source             = "../components/diagnostic_setting"
  resource_type      = "key_vault"
  retention          = "${var.diagnostic_retentions["key_vault"]}"
  storage_account_id = "${module.monitoring.primary_diagnostics_storage_account_id}"
  oms_workspace_id   = "${module.monitoring.oms_workspace_id}"
}
