PACKET_API_TOKEN := $(shell cat $(DBKEY)/packet.api.token)
PACKET_PROJECT_ID :=  $(shell cat $(DBKEY)/packet.project.id)
CLOUDFLARE_API_TOKEN := $(shell cat $(DBKEY)/cloudflare.api.token)

tfopts := -state '$(tfstatefs)'  \
		-var 'packet_api_token=$(PACKET_API_TOKEN)' \
		-var 'packet_project_id=$(PACKET_PROJECT_ID)' \
		-var 'cloudflare_api_token=$(CLOUDFLARE_API_TOKEN)' \
		-var 'machine_zone=$(MACHINE_ZONE)' \
		-var 'stack_zone=$(STACK_ZONE)' \

l0-init-packet:
	mkdir -p $(tfstatedir)
	terraform init $(tfdir)

l0-plan-packet:
	terraform plan $(tfopts) $(tfdir) 

l0-apply-packet:
	terraform apply $(tfopts) $(tfdir) 

l0-destroy-packet:
	terraform destroy $(tfopts) $(tfdir) 
