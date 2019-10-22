data "cloudflare_zones" "node" {
  filter {
    name   = var.machine_zone
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "node" {
  zone_id = "${lookup(data.cloudflare_zones.node.zones[0], "id")}"
  name    = "node"
  value   = packet_device.node.access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "node_wc" {
  zone_id = "${lookup(data.cloudflare_zones.node.zones[0], "id")}"
  name    = "*.node"
  value   = packet_device.node.access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = false
}

output "node_zone_record" {
  value = "${packet_device.node.access_public_ipv4} ${cloudflare_record.node.hostname}" 
}

output "node_zone_record_wc" {
  value = "${packet_device.node.access_public_ipv4} ${cloudflare_record.node_wc.hostname}" 
}
