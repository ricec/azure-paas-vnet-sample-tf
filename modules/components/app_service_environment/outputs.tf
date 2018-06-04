output "ase_id" {
  value = "${azurerm_template_deployment.ase.outputs["aseId"]}"
}

output "ilb_ip" {
  value = "${data.external.ilb_ip.result["ilb_ip"]}"
}
