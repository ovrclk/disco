L0DIR      ?= $(PWD)
PROFILE    ?= packet

tfdir      ?= $(L0DIR)/$(PROFILE)
tfstatedir ?= $(DATADIR)/state/$(PROFILE)
tfstatefs  ?= $(tfstatedir)/state.tf
# tfvarfile  ?= $(tfstatedir)/vars.tf.json

# layer0-init: layer0-init.$(TIER)
# layer0-init.%:
# 	$(eval tier := $(@:layer0-init.%=%))
# 	$(MAKE) layer0-init-${tier}

# .PHONY: .PHONY layer0-init layer0-init.% 

# layer0-plan: layer0-plan.$(TIER)
# layer0-plan.%: 
# 	$(eval tier := $(@:layer0-plan.%=%))
# 	$(MAKE) layer0-plan-${tier}

# .PHONY: .PHONY layer0-plan layer0-plan.% 

# layer0-apply: layer0-apply.$(TIER)
# layer0-apply.%:
# 	$(eval tier := $(@:layer0-apply.%=%))
# 	$(MAKE) layer0-apply-${tier}

# .PHONY: .PHONY layer0-apply layer0-apply.% 

# layer0-destroy: layer0-destroy.$(TIER)
# layer0-destroy.%:
# 	$(eval tier := $(@:layer0-destroy.%=%))
# 	$(MAKE) layer0-destroy-${tier}
# .PHONY: .PHONY layer0-destroy layer0-destroy.%

include $(L0DIR)/$(PROFILE)/make.mk
