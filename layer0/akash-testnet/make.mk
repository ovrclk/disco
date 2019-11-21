PACKET_API_TOKEN     ?= $(shell [ -f $(DBKEY)/packet.api.token ] && cat $(DBKEY)/packet.api.token)
PACKET_PROJECT_ID    ?= $(shell [ -f $(DBKEY)/packet.project.id ] && cat $(DBKEY)/packet.project.id)
CLOUDFLARE_API_TOKEN ?= $(shell [ -f $(DBKEY)/cloudflare.api.token ] && cat $(DBKEY)/cloudflare.api.token)

tfopts := -state '$(tfstatefs)'  \
		-var 'packet_api_token=$(PACKET_API_TOKEN)' \
		-var 'packet_project_id=$(PACKET_PROJECT_ID)' \
		-var 'cloudflare_api_token=$(CLOUDFLARE_API_TOKEN)' \
		-var 'machine_zone=$(MACHINE_ZONE)' \
		-var 'stack_zone=$(STACK_ZONE)'

layer0-init:
	@mkdir -p $(tfstatedir)
	@terraform init $(tfdir)

layer0-plan:
	@terraform plan $(tfopts) $(tfdir) 

layer0-apply:
	@terraform apply $(tfopts) $(tfdir) 

layer0-destroy:
	@terraform destroy $(tfopts) $(tfdir) 

.PHONY: .PHONY layer0-init layer0-plan layer0-apply layer0-destroy
