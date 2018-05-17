output "key_vault_id" {
  value = "${azurerm_key_vault.main.id}"
}

output "apim_cert_secret_name" {
  value = "${var.apim_cert_config["cert_name"]}"
}

output "apim_cert" {
  value = "${data.external.apim_ssl_cert.result}"
}

output "ase_cert_secret_name" {
  value = "${var.ase_cert_config["cert_name"]}"
}

output "ase_cert" {
  value = "${data.external.ase_ssl_cert.result}"
}

