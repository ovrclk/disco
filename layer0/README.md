# layer0

Core Infrastructure scripts for managing Overclock Labs Infrastructure

Terraform scripts for provisioning core Overclock Servers on Packet. These servers manage critical overclock infrastructure

Extreme caution must be excercized when making changes.

Status: [status.ovrclk.net](https://status.ovrclk.net)

## Authentication

## ENV Variables

- `TF_VAR_packet_auth_token`: Authentication Token for Packet
- `TF_VAR_cloudflare_token`: Authentication Token for Cloudflare

## Terraform Cloud

Please ask an Adminstrator for access to ovrclk on [Terraform Cloud](https://app.terraform.io/app/ovrclk). Once you have access, create a auth token and terraform config file

```
$ export TF_TOKEN=5lsdovPZB...

# cat >  ~/.terraformrc
credentials "app.terraform.io" {
  token = "$TF_TOKEN"
}
```

## Setup

- Terraform v0.12.9

### Terraform

To install dependencies on OSX using brew, run `brew update && brew install terraform`

## Usage

- init: `make init`
- plan: `make plan`
- apply: `make apply`
