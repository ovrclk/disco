L0DIR      ?= $(PWD)
TIER       ?= packet

tfdir      ?= $(L0DIR)/$(TIER)
tfstatedir ?= $(DATADIR)/state/$(MACHINE_ZONE)/$(TIER)
tfstatefs  ?= $(tfstatedir)/state.tf
tfvarfile  ?= $(tfstatedir)/vars.tf.json

layer0-init:
	mkdir -p $(tfstatedir)
	terraform init $(tfdir)

layer0-plan: 
	terraform plan -var-file=$(tfvarfile) -tf-state=$(tfstatefs) $(tfdir)

layer0-apply:
	terraform apply -var-file=$(tfvarfile) -tf-state=$(tfstatefs) $(tfdir)

layer0-init.%:
	$(eval tier := $(@:layer0-init.%=%))
	$(MAKE) l0-init-${tier}

layer0-plan.%: 
	$(eval tier := $(@:layer0-plan.%=%))
	$(MAKE) l0-plan-${tier}

layer0-apply.%:
	$(eval tier := $(@:layer0-apply.%=%))
	$(MAKE) l0-apply-${tier}

include $(L0DIR)/packet/make.mk
