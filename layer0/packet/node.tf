resource "packet_device" "node" {
  hostname         = "${var.machine_name}.${var.packet_facility}.${var.machine_zone}"
  plan             = var.packet_plan
  facilities       = ["${var.packet_facility}"]
  operating_system = var.packet_os
  billing_cycle    = "hourly"
  project_id       = var.packet_project_id
}

/* Outputs */
output "node_root_password" {
  value       = packet_device.node.root_password
  description = "root password to the server:k1 (disabled after 24 hours)"
}

output "node_access_public_ipv4" {
  value = packet_device.node.access_public_ipv4
}
