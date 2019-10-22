variable "packet_os" {
  type    = "string"
  default = "ubuntu_19_04"
}

variable "packet_plan" {
  type    = "string"
  default = "c1.small.x86"
}

variable "packet_facility" {
  type    = "string"
  default = "sjc1"
}

provider "packet" {
  version    = "~> 2.4"
  auth_token = "${var.packet_api_token}"
}

provider "cloudflare" {
  version = "~> 2.0"
  api_token = var.cloudflare_api_token
}
