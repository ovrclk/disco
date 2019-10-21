/* DNS */
resource "cloudflare_record" "metrics" {
  zone_id = "${lookup(data.cloudflare_zones.ovrclk_net.zones[0], "id")}"
  name    = "metrics"
  value   = "kernel.ovrclk.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "status" {
  zone_id = "${lookup(data.cloudflare_zones.ovrclk_net.zones[0], "id")}"
  name    = "status"
  value   = "kernel.ovrclk.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "packet_device" "k1" {
  hostname         = "k1.ovrclk.net"
  plan             = "${var.packet_plan}"
  facilities       = ["${var.packet_facility}"]
  operating_system = "ubuntu_19_04"
  billing_cycle    = "hourly"
  project_id       = var.packet_project_id
}
resource "cloudflare_record" "k1" {
  zone_id = "${lookup(data.cloudflare_zones.ovrclk_net.zones[0], "id")}"
  name    = "k1"
  value   = packet_device.k1.access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = false
}
resource "cloudflare_record" "kernal1" {
  zone_id = "${lookup(data.cloudflare_zones.ovrclk_net.zones[0], "id")}"
  name    = "kernel"
  value   = packet_device.k2.access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = false
}
resource "cloudflare_record" "kernal2" {
  zone_id = "${lookup(data.cloudflare_zones.ovrclk_net.zones[0], "id")}"
  name    = "kernel"
  value   = packet_device.k1.access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = false
}
/* Outputs */
output "k1_root_password" {
  value       = packet_device.k1.root_password
  description = "root password to the server:k1 (disabled after 24 hours)"
}
output "k1_access_public_ipv4" {
  value = packet_device.k1.access_public_ipv4
}

