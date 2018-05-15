provider "azurerm" {}

resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

module "app_service_plan" {
  source                     = "../app_service_plan"
  name                       = "${var.resource_prefix}-asp"
  friendly_location_name     = "${var.location}"
  resource_group_name        = "${var.resource_group_name}"
  app_service_environment_id = "${var.ase_id}"
  sku_name                   = "${var.app_service_plan_sku_name}"
}

resource "azurerm_app_service" "main" {
  name                    = "${var.resource_prefix}-web-app"
  location                = "${azurerm_resource_group.main.location}"
  resource_group_name     = "${azurerm_resource_group.main.name}"
  app_service_plan_id     = "${module.app_service_plan.id}"
  client_affinity_enabled = false
  tags                    = "${var.tags}"

  site_config {
    always_on              = true
    java_version           = "1.7"
    java_container         = "JETTY"
    java_container_version = "9.3"
  }

  # TODO - Figure out diagnostic logging for web apps
}
