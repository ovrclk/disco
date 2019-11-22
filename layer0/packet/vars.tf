# Required variables
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

variable "machine_name" {
  type    = "string"
  default = "akash"
}

variable "packet_os" {
  type    = "string"
  default = "ubuntu_18_04"
}

variable "packet_plan" {
  type    = "string"
  default = "t1.small.x86"
}

variable "packet_facility" {
  type    = "string"
  default = "sjc1"
}
