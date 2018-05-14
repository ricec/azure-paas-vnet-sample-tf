# NOTE: A template deployment is used in favor of the azurerm_app_service_plan
# resource, as there are currently bugs that prevent using this resource with
# ASEs.

resource "azurerm_template_deployment" "main" {
  name                = "app-service-plan-${var.name}"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/app_service_plan.json")}"
  deployment_mode     = "Incremental"

  parameters {
    planName = "${var.name}"
    aseId    = "${var.app_service_environment_id}"
    location = "${var.friendly_location_name}"
    skuName  = "${var.sku_name}"
    tags     = "${jsonencode(var.tags)}"
  }
}
