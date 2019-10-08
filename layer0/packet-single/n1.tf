resource "packet_device" "n1" {
  hostname           = "n1.${var.packet_plan}"
  plan               = "${var.packet_plan}"
  facilities         = ["${var.packet_facility}"]
  operating_system   = "ubuntu_18_04"
  billing_cycle      = "hourly"
  project_id         = var.packet_project_id
}

/* Outputs */
output "k1_root_password" {
  value = packet_device.k1.root_password
  description = "root password to the server:k1 (disabled after 24 hours)"
}

output "k1_access_public_ipv4" {
  value = packet_device.k1.access_public_ipv4
}
