output "cert_name" {
  value = "${var.cert_name}"
}

output "public_cer" {
  value = "${data.external.cert.result["public_cer"]}"
}

output "private_pfx" {
  value     = "${data.external.cert.result["private_pfx"]}"
  sensitive = true
}
