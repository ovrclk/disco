variable "packet_api_token" {
  type = "string"
}

variable "packet_project_id" {
  type = "string"
}

variable "cloudflare_api_token" {
  type = "string"
}

variable "packet_plan" {
  type    = "string"
  default = "c1.small.x86"
}

variable "packet_facility" {
  type    = "string"
  default = "sjc1"
}

variable "host_dns_zone" {
  default     = "ovrclk.net"
  description = "DNS zone for hosts"
}

variable "testnet_dns_zone" {
  default     = "akashtest.net"
  description = "DNS zone for nodes"
}

variable "regions" {
  type = "map"

  default = {
    ams1 = "ams1"
    ewr1 = "ewr1"
    sjc1 = "sjc1"
    nrt1 = "nrt1"
  }
}

variable "pro" {
  type = "map"

  default = {
    kant   = "ewr1"
    marx   = "ewr1"
    plato  = "ams1"
    freud  = "ams1"
    locke  = "sjc1"
    roy    = "sjc1"
    burke  = "nrt1"
    pascal = "nrt1"

    node1 = "sjc1"
    node2 = "sjc1"
    node3 = "sjc1"

    alice = "sjc1"
  }
}
