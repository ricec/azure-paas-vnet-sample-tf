data "template_file" "log_settings" {
  count    = "${length(keys(var.diagnostic_profiles))}"
  template = "${file("${path.module}/diagnostics/${element(keys(var.diagnostic_profiles), count.index)}_logs.json.tpl")}"

  vars {
    retention = "${lookup(var.diagnostic_profiles, element(keys(var.diagnostic_profiles), count.index))}"
  }
}

data "template_file" "metric_settings" {
  count    = "${length(keys(var.diagnostic_profiles))}"
  template = "${file("${path.module}/diagnostics/${element(keys(var.diagnostic_profiles), count.index)}_metrics.json.tpl")}"

  vars {
    retention = "${lookup(var.diagnostic_profiles, element(keys(var.diagnostic_profiles), count.index))}"
  }
}

data "template_file" "create_diagnostic_settings_command" {
  count    = "${length(keys(var.diagnostic_profiles))}"
  template = "${file("${path.module}/scripts/create_diagnostic_settings.sh.tpl")}"

  vars {
    logs_json          = "${data.template_file.log_settings.*.rendered[count.index]}"
    metrics_json       = "${data.template_file.metric_settings.*.rendered[count.index]}"
    storage_account_id = "${azurerm_storage_account.diagnostics.id}"
    oms_workspace_id   = "${azurerm_log_analytics_workspace.monitoring.id}"
  }
}
