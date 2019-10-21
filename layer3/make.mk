NODE 				?= node1
L3_DOMAIN 	= akashtest.net
CONFIG_DIR 	?= $(L3DIR)/.data
PROVIDER 		?= alice
REGION 			?= sjc
IMAGE_TAG 	?= 0.5.1
AKASH_NS 		?= akash-sys
HELM_FLAGS 	= #--dry-run --debug

akashd-init:
	mkdir -p $(DATADIR)/nodes
	akashd init -t helm -o $(DATADIR)/nodes -n $(call join-with,$(comma),$(NODES)) $(shell akash key show master --public)

akash-remove: delmanifests
	$(KC) helm list | grep akash-sys | awk '{print $$1}' | xargs helm del --purge $(HELM_FLAGS)
	$(KC) kubectl delete namespace $(AKASH_NS)

akash-node-install:
	$(KC) kubectl create namespace $(AKASH_NS) || true
	$(KC) helm install $(L3DIR)/akash-node $(HELM_FLAGS) --namespace=$(AKASH_NS) \
		--name $(NODE) \
		--set "image.tag=$(IMAGE_TAG)" \
		--set "ingress.domain=$(NODE).$(L3_DOMAIN)" -f $(DATADIR)/db/config/nodes/$(NODE).yaml

akash-node-install-all:
	$(foreach node, $(NODES), $(MAKE) akash-node-install.$(node))

akash-node-install.%:
	$(eval node := $(@:akash-node-install.%=%))
	$(MAKE) NODE=$(node) akash-node-install || true

.PHONY: .PHONY akash-node-install akash-node-install.% akash-node-install-all

akash-node-remove:
	$(KC) helm del --purge $(NODE)

akash-node-remove-all:
	$(foreach node, $(NODES), $(MAKE) akash-node-remove.$(node))

akash-node-remove.%:
	$(eval node := $(@:akash-node-remove.%=%))
	$(MAKE) NODE=$(node) akash-node-remove || true

.PHONY: .PHONY akash-node-remove akash-node-remove.% akash-node-remove-all

akash-provider-register: 
	[[ -f "$(DB)/keys/$(PROVIDER).address" ]] || akash provider add $(DBCFG)/providers/$(PROVIDER).yml -k $(PROVIDER) \
			| grep Key: \
			| awk '{print $$2}' > $(DB)/keys/$(PROVIDER).address

.PHONY: .PHONY akash-provider-register

akash-provider-install: akash-provider-key-install akash-provider-register
	$(KC) kubectl create namespace $(AKASH_NS) || true
	$(KC) helm install $(L3DIR)/akash-provider $(HELM_FLAGS) --namespace=$(AKASH_NS) \
		--name "$(PROVIDER)" \
		--set "image.tag=$(IMAGE_TAG)" \
		--set "ingress.domain=$(PROVIDER).$(L3_DOMAIN)" \
		--set "provider.address=$(shell cat $(DBKEY)/$(PROVIDER).address)"

akash-provider-remove: akash-provider-key-remove
	$(KC) helm del --purge $(PROVIDER)

.PHONY: .PHONY akash-provider-install akash-provider-remove

akash-provider-install-all:
	$(foreach provider, $(DB_PROVIDERS), $(MAKE) akash-provider-install.$(provider))

akash-provider-install.%:
	$(eval provider := $(@:akash-provider-install.%=%))
	$(eval host := $(shell cat $(DBKEY)/$(provider).host) )
	$(MAKE) HOST=$(host) PROVIDER=$(provider) akash-provider-install || true

.PHONY: .PHONY akash-provider-install akash-provider-install.% akash-provider-install-all

akash-provider-remove-all:
	$(foreach provider, $(DB_PROVIDERS), $(MAKE) akash-provider-remove.$(provider))

akash-provider-remove.%:
	$(eval provider := $(@:akash-provider-remove.%=%))
	$(eval host := $(shell cat $(DBKEY)/$(provider).host) )
	$(MAKE) HOST=$(host) PROVIDER=$(provider) akash-provider-remove || true

.PHONY: .PHONY akash-provider-remove akash-provider-remove.% akash-provider-remove-all

akash-provider-key-install:
	$(KCTL) create namespace $(AKASH_NS) || true
	akash key show $(PROVIDER) --private > $(DB)/keys/$(PROVIDER).private
	$(KCTL) create --namespace $(AKASH_NS) secret generic $(PROVIDER)-akash-provider-private-key \
		--from-file=$(DB)/keys/$(PROVIDER).private

akash-provider-key-remove:
	$(KC) kubectl delete secret --namespace=$(AKASH_NS) $(PROVIDER)-akash-provider-private-key 

.PHONY: .PHONY akash-provider-key-install akash-provider-key-remove

akash-provider-restart-all:
	$(foreach provider, $(DB_PROVIDERS), $(MAKE) akash-provider-restart.$(provider))

akash-provider-restart.%:
	$(eval provider := $(@:akash-provider-restart.%=%))
	$(eval host := $(shell cat $(DBKEY)/$(provider).host) )
	KUBECONFIG=$(DB)/config/kube/$(host) kubectl delete pods -n $(AKASH_NS) -l release=$(provider) || true

.PHONY: .PHONY akash-provider-restart.% akash-provider-restart-all

akash-provider-reset-all:
	$(foreach provider, $(DB_PROVIDERS), $(MAKE) akash-provider-reset.$(provider))

akash-provider-reset.%:
	$(eval provider := $(@:akash-provider-reset.%=%))
	$(eval host := $(shell cat $(DBKEY)/$(provider).host) )
	$(MAKE) HOST=$(host) PROVIDER=$(provider) akash-provider-remove || true
	$(MAKE) HOST=$(host) PROVIDER=$(provider) akash-provider-install || true

.PHONY: .PHONY akash-provider-reset.% akash-provider-reset-all

akash-provider-check-all:
	$(foreach provider, $(DB_PROVIDERS), $(MAKE) akash-provider-check.$(provider))

akash-provider-check.%:
	$(eval provider := $(@:akash-provider-check.%=%))
	$(eval host := $(shell cat $(DBKEY)/$(provider).host) )
	KUBECONFIG=$(DB)/config/kube/$(host) kubectl get pods -n $(AKASH_NS) -l release=$(provider) || true

.PHONY: .PHONY akash-provider-check.% akash-provider-check-all

deldeps:
	for d in "$(shell akash query deployment -k master | grep ACTIVE | awk '{print $$1}')" ;do akash deployment close $$d -k master ; done

akash-provider-delmani-all:
	$(foreach provider, $(DB_PROVIDERS), $(MAKE) akash-provider-delmani.$(provider))

akash-provider-delmani.%:
	$(eval provider := $(@:akash-provider-delmani.%=%))
	$(eval host := $(shell cat $(DBKEY)/$(provider).host) )
	KUBECONFIG=$(DB)/config/kube/$(host) kubectl get manifests -n lease | awk '{print $$1}' | xargs kubectl delete manifest -n lease || true

delmanifests:
	$(KC) kubectl get manifests -n lease | awk '{print $$1}' | xargs kubectl delete manifest -n lease
