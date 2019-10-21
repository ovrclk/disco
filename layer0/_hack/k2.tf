resource "packet_device" "k2" {
  hostname         = "k2.ovrclk.net"
  plan             = "${var.packet_plan}"
  facilities       = ["${var.packet_facility}"]
  operating_system = "ubuntu_19_04"
  billing_cycle    = "hourly"
  project_id       = var.packet_project_id
}
resource "cloudflare_record" "k2" {
  zone_id = "${lookup(data.cloudflare_zones.ovrclk_net.zones[0], "id")}"
  name    = "k2"
  value   = packet_device.k2.access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = false
}
/* Outputs */
output "k2_root_password" {
  value       = packet_device.k2.root_password
  description = "root password to the server:k1 (disabled after 24 hours)"
}
output "k2_access_public_ipv4" {
  value = packet_device.k2.access_public_ipv4
}

