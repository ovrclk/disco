data "cloudflare_zones" "stack" {
  filter {
    name   = var.stack_zone
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "pro" {
  count   = length(keys(var.pro))
  zone_id = "${lookup(data.cloudflare_zones.stack.zones[0], "id")}"
  name    = keys(var.pro)[count.index]
  value   = "${lookup(var.pro, keys(var.pro)[count.index])}.${var.machine_zone}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "pro_wc" {
  count   = length(keys(var.pro))
  zone_id = "${lookup(data.cloudflare_zones.stack.zones[0], "id")}"
  name    = "*.${keys(var.pro)[count.index]}"
  value   = "${lookup(var.pro, keys(var.pro)[count.index])}.${var.machine_zone}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "testnet" {
  count   = length(keys(var.api_endpoints))
  zone_id = "${lookup(data.cloudflare_zones.stack.zones[0], "id")}"
  name    = keys(var.api_endpoints)[count.index]
  value   = "${lookup(var.api_endpoints, keys(var.api_endpoints)[count.index])}.${var.machine_zone}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}
