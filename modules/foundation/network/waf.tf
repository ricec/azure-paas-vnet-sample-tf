resource "azurerm_public_ip" "waf" {
  name                         = "${var.region["prefix"]}-waf-ip"
  location                     = "${var.region["location"]}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "dynamic"
  tags                         = "${var.tags}"
}

resource "azurerm_application_gateway" "waf" {
  name                = "${var.region["prefix"]}-waf"
  location            = "${var.region["location"]}"
  resource_group_name = "${var.resource_group_name}"
  tags                = "${var.tags}"

  sku {
    tier     = "WAF"
    name     = "${var.waf_sku}"
    capacity = "${var.waf_capacity}"
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = "${azurerm_subnet.waf.id}"
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
    data     = "${var.apim_private_pfx}"
    password = ""
  }

  authentication_certificate {
    name = "apimPublicKey"
    data = "${var.apim_public_cer}"
  }

  backend_address_pool {
    name      = "apimBackendPool"
    fqdn_list = ["${var.region["apim_hostname"]}"]
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
    host                = "${var.region["apim_hostname"]}"
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
