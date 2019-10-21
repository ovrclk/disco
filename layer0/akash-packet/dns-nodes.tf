data "cloudflare_zones" "hosts" {
  filter {
    name   = "ovrclk.net"
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "hosts" {
  count   = length(keys(var.regions))
  zone_id = "${lookup(data.cloudflare_zones.hosts.zones[0], "id")}"
  name    = keys(var.regions)[count.index]
  value   = packet_device.hosts[count.index].access_public_ipv4
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "region_metrics" {
  count   = length(keys(var.regions))
  zone_id = "${lookup(data.cloudflare_zones.hosts.zones[0], "id")}"
  name    = "metrics.${keys(var.regions)[count.index]}"
  value   = cloudflare_record.hosts[count.index].hostname
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "status_region" {
  count   = length(keys(var.regions))
  zone_id = "${lookup(data.cloudflare_zones.hosts.zones[0], "id")}"
  name    = "status.${keys(var.regions)[count.index]}"
  value   = cloudflare_record.hosts[count.index].hostname
  type    = "CNAME"
  ttl     = 1
  proxied = true
}
