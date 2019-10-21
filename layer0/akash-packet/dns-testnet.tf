data "cloudflare_zones" "testnet" {
  filter {
    name   = var.testnet_dns_zone
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "pro" {
  count   = length(keys(var.pro))
  zone_id = "${lookup(data.cloudflare_zones.testnet.zones[0], "id")}"
  name    = keys(var.pro)[count.index]
  value   = "${lookup(var.pro, keys(var.pro)[count.index])}.${var.host_dns_zone}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "pro_wc" {
  count   = length(keys(var.pro))
  zone_id = "${lookup(data.cloudflare_zones.testnet.zones[0], "id")}"
  name    = "*.${keys(var.pro)[count.index]}"
  value   = "${lookup(var.pro, keys(var.pro)[count.index])}.${var.host_dns_zone}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}
