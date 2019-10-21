resource "packet_device" "k3" {
  hostname         = "k3.ovrclk.net"
  plan             = "${var.packet_plan}"
  facilities       = ["${var.packet_facility}"]
  operating_system = "ubuntu_19_04"
  billing_cycle    = "hourly"
  project_id       = var.packet_project_id
}
/* Outputs */
output "k3_root_password" {
  value       = packet_device.k3.root_password
  description = "root password to the server:k1 (disabled after 24 hours)"
}
output "k3_access_public_ipv4" {
  value = packet_device.k3.access_public_ipv4
}
resource "cloudflare_record" "k3" {
  zone_id = "${lookup(data.cloudflare_zones.ovrclk_net.zones[0], "id")}"
  name    = "k3"
  value   = packet_device.k3.access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = false
}

