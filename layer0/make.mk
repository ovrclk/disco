L0DIR 	?= $(PWD)
# cloud service provider
CSP 		?= akash-packet

tfvars 	= -var-file=$(DATADIR)/terraform/$(CSP)/terraform.tfvars.json
tfstate = -state=$(DATADIR)/terraform/$(CSP)/state.tf
tfdir 	= $(L0DIR)/$(CSP)

layer0-init:
	terraform init $(tfdir)

layer0-plan: 
	terraform plan $(tfvars) $(tfstate) $(tfdir)

layer0-apply:
	terraform apply $(tfvars) $(tfstate) -auto-approve $(tfdir)
