resource "azurerm_public_ip" "waf" {
  name                         = "${module.primary_region.config["prefix"]}-waf-ip"
  location                     = "${module.primary_region.config["location"]}"
  resource_group_name          = "${azurerm_resource_group.networking.name}"
  public_ip_address_allocation = "dynamic"
  tags                         = "${local.networking_tags}"
}

resource "azurerm_application_gateway" "waf" {
  name                = "${module.primary_region.config["prefix"]}-waf"
  location            = "${module.primary_region.config["location"]}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  tags                = "${local.networking_tags}"

  sku {
    tier     = "WAF"
    name     = "${var.waf_sku}"
    capacity = "${var.waf_capacity}"
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = "${module.networking.vnet_id}/subnets/${module.networking.waf_subnet_name}"
  }

  frontend_ip_configuration {
    name                 = "frontendIp"
    public_ip_address_id = "${azurerm_public_ip.waf.id}"
  }

  frontend_port {
    name = "httpsFrontendPort"
    port = 443
  }

  ssl_certificate {
    name     = "gatewayCert"
    data     = "${module.apim_cert.private_pfx}"
    password = ""
  }

  authentication_certificate {
    name = "apimPublicKey"
    data = "${module.apim_cert.public_cer}"
  }

  backend_address_pool {
    name      = "apimBackendPool"
    fqdn_list = ["${local.apim_primary_hostname}"]
  }

  backend_http_settings {
    name                       = "httpsBackendSettings"
    port                       = 443
    protocol                   = "Https"
    cookie_based_affinity      = "Disabled"
    request_timeout            = 1
    probe_name                 = "apimHttpsProbe"
    authentication_certificate {
      name = "apimPublicKey"
    }
  }

  http_listener {
    name                           = "apimProxyListener"
    frontend_ip_configuration_name = "frontendIp"
    frontend_port_name             = "httpsFrontendPort"
    protocol                       = "Https"
    ssl_certificate_name           = "gatewayCert"
  }

  request_routing_rule {
    name                       = "apimProxyRule"
    rule_type                  = "Basic"
    http_listener_name         = "apimProxyListener"
    backend_address_pool_name  = "apimBackendPool"
    backend_http_settings_name = "httpsBackendSettings"
  }

  probe {
    name                = "apimHttpsProbe"
    protocol            = "Https"
    path                = "/status-0123456789abcdef"
    host                = "${local.apim_primary_hostname}"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 8
  }

  disabled_ssl_protocols = ["TLSv1_0", "TLSv1_1"]

  waf_configuration {
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.0"
    enabled = true
  }

  provisioner "local-exec" {
    command = "${module.app_gateway_diagnostics.command}"

    environment {
      resource_id = "${azurerm_application_gateway.waf.id}"
    }
  }
}
