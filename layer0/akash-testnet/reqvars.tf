variable "machine_zone" {
  type = "string"
}

variable "stack_zone" {
  type = "string"
}

variable "packet_api_token" {
  type = "string"
}

variable "packet_project_id" {
  type = "string"
}

variable "cloudflare_api_token" {
  type = "string"
}

variable "regions" {
  description = "A map of nodes to facilities (regions)"
  type        = "map"

  default = {
    sjc1 = "sjc1"
    sjc2 = "sjc1"
    ams1 = "ams1"
    ewr1 = "ewr1"
  }
}

variable "api_endpoints" {
  default = {
    api   = "sjc1"
    node1 = "sjc1"
    node1 = "sjc1"
    node3 = "sjc1"
  }
}

variable "pro" {
  description = "A map of providers to nodes"
  type        = "map"

  default = {
    locke = "sjc2"
    plato = "ams1"
    kant  = "ewr1"
  }
}
