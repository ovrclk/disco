NODE 				?= node1
L3_DOMAIN 	= akashtest.net
CONFIG_DIR 	?= $(L3DIR)/.data
PROVIDER 		?= kant
REGION 			?= sjc
IMAGE_TAG 	?= 0.5.2
AKASH_NS 		?= akash-sys
HELM_FLAGS 	= #--dry-run --debug
NODES 			= $(shell cat $(DATADIR)/db/index/NODES)

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
		--set "ingress.domain=$(NODE).$(L3_DOMAIN)" -f $(DATADIR)/nodes/$(NODE).yaml

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
	akash provider add $(DATADIR)/providers/$(PROVIDER).yml -k $(PROVIDER) |  grep Key: | awk '{print $$2}' > $(CONFIG_DIR)/providers/$(PROVIDER).address

.PHONY: .PHONY akash-provider-register

akash-provider-key-install:
	$(KCTL) create namespace $(AKASH_NS) || true
	mkdir -p $(CONFIG_DIR)/$(PROVIDER)
	akash key show $(PROVIDER) --private > $(CONFIG_DIR)/$(PROVIDER)/key
	$(KCTL) create --namespace $(AKASH_NS) secret generic $(PROVIDER)-akash-provider-private-key --from-file=$(CONFIG_DIR)/$(PROVIDER)/key

akash-provider-key-remove:
	$(KC) kubectl delete secret --namespace=$(AKASH_NS) $(PROVIDER)-akash-provider-private-key 

.PHONY: .PHONY akash-provider-key-install akash-provider-key-remove

akash-provider-install: akash-provider-key-install
	$(KC) kubectl create namespace $(AKASH_NS) || true
	$(KC) helm install $(L3DIR)/akash-provider $(HELM_FLAGS) --namespace=$(AKASH_NS) \
		--name "$(PROVIDER)" \
		--set "image.tag=$(IMAGE_TAG)" \
		--set "ingress.domain=$(PROVIDER).$(DOMAIN)" \
		--set "provider.address=$(shell cat $(CONFIG_DIR)/providers/$(PROVIDER).address)"

akash-provider-remove: akash-provider-key-remove
	$(KC) helm del --purge $(PROVIDER)

.PHONY: .PHONY akash-provider-install akash-provider-remove

deldeps:
	for d in "$(shell akash query deployment -k master | grep ACTIVE | awk '{print $$1}')" ;do akash deployment close $$d -k master ; done

delmanifests:
	$(KC) kubectl get manifests -n lease | awk '{print $$1}' | xargs kubectl delete manifest -n lease

checkprovs:
	for h in ams1 sjc1 ewr1 nrt1 ; do KUBECONFIG=$(BASDIR)/.data/$$h.ovrclk.net/kubeconfig kubectl get pods -n akash-sys -l app=akash-provider ; done

delprovpods:
	for h in ams1 sjc1 ewr1 nrt1 ; do KUBECONFIG=$(BASDIR)/.data/$$h.ovrclk.net/kubeconfig kubectl delete pods -n akash-sys -l app=akash-provider ; done
