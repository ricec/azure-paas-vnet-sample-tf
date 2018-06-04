data "template_file" "log_settings" {
  template = "${file("${path.module}/templates/${var.resource_type}_logs.json.tpl")}"

  vars {
    retention = "${var.retention}"
  }
}

data "template_file" "metric_settings" {
  template = "${file("${path.module}/templates/${var.resource_type}_metrics.json.tpl")}"

  vars {
    retention = "${var.retention}"
  }
}

data "template_file" "create_diagnostic_settings_command" {
  template = "${file("${path.module}/scripts/create_diagnostic_settings.sh.tpl")}"

  vars {
    logs_json          = "${data.template_file.log_settings.rendered}"
    metrics_json       = "${data.template_file.metric_settings.rendered}"
    storage_account_id = "${var.storage_account_id}"
    oms_workspace_id   = "${var.oms_workspace_id}"
  }
}
