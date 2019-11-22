provider "packet" {
  version    = "~> 2.4"
  auth_token = "${var.packet_api_token}"
}

provider "cloudflare" {
  version = "~> 2.0"
  api_token = var.cloudflare_api_token
}
