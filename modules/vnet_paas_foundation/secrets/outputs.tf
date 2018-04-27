output "apim_cert" {
  value = "${data.external.apim_ssl_cert.result}"
}

output "ase_cert" {
  value = "${data.external.ase_ssl_cert.result}"
}

