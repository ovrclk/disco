resource "packet_device" "node" {
  count            = length(keys(var.regions))
  hostname         = "${keys(var.regions)[count.index]}.${var.machine_zone}"
  plan             = var.packet_plan
  facilities       = ["${var.regions[keys(var.regions)[count.index]]}"]
  operating_system = var.packet_os
  billing_cycle    = "hourly"
  project_id       = var.packet_project_id
}

# outputs
output "node_root_password" {
  value       = packet_device.node.*.root_password
  description = "root password to the server:k1 (disabled after 24 hours)"
  sensitive   = true
}

output "node_access_public_ipv4" {
  value = packet_device.node.*.access_public_ipv4
}
