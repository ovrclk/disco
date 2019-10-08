# Layer 0

Terraform scripts for provisioning a bare metal servers on Packet.  Extreme caution must be excercized when making changes.

## Authentication

## ENV Variables

- `TF_VAR_packet_auth_token`: Authentication Token for Packet
- `TF_VAR_packet_project_id`: Packet Project ID

## Terraform Cloud

Sign up for an account on [Terraform Cloud](https://app.terraform.io). Once you have access, create a auth token and terraform config file

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

### Ansible

`$ sudo pip install ansible`
