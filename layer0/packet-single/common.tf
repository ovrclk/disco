/* variables */
variable "domain_name" {
  type = "string"
}

variable "packet_auth_token" {
  type = "string"
}

variable "packet_project_id" {
  type    = "string"
  default = "string"
}

variable "packet_plan" {
  type    = "string"
  default = "c1.small.x86"
}

variable "packet_facility" {
  type    = "string"
  default = "sjc1"
}

/* Terraform remote state management */

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ovrclk"

    workspaces {
      name = "kernel"
    }
  }
}

provider "packet" {
  version    = "~> 2.4"
  auth_token = "${var.packet_auth_token}"
}
