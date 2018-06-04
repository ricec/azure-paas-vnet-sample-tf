output "zone_name" {
  value = "${null_resource.dns.triggers["zone_name"]}"
}
