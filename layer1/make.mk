L1DIR          ?= $(CURDIR)
CSP            ?= packet
KUBE_NAMESPACE  = kube-system
SSH_KEY        ?= $(HOME)/.ssh/id_rsa

layer1-install: kube-install

layer1-remove: kube-remove 

layer1-install.%:
	$(eval host := $(@:layer1-install.%=%))
	$(MAKE) HOST=$(host) layer1-install || true

layer1-install-all:
	$(foreach host, $(ALL_HOSTS), $(MAKE) layer1-install.$(host))

layer1-remove.%:
	$(eval host := $(@:layer1-remove.%=%))
	$(MAKE) HOST=$(host) layer1-remove || true

layer1-remove-all:
	$(foreach host, $(ALL_HOSTS), $(MAKE) layer1-remove.$(host))

layer1-check-all:
	$(foreach host, $(ALL_HOSTS), $(MAKE) layer1-check.$(host))

layer1-check.%:
	$(eval host := $(@:layer1-check.%=%))
	$(MAKE) HOST=$(host) layer1-check || true

layer1-check:
	KUBECONFIG=$(KUBECONFIG) kubectl cluster-info 

.PHONY: .PHONY layer1-install layer1-remove layer1-install.% layer1-install-all layer1-remove.% layer1-remove-all layer1-check.% layer1-check

kube-install: kube-config-path
	k3sup install --ip $(MASTER_IP) --user $(SSHUSER) --local-path $(KUBECONFIG) --k3s-version=$(K3S_VERSION) \
		--ssh-key=$(SSH_KEY) #--k3s-extra-args '--no-deploy traefik'

kube-remove: checkaction
	ssh $(SSHUSER)@$(MASTER_IP) "k3s-uninstall.sh"
	rm $(KUBECONFIG)

.PHONY: .PHONY kube-install kube-remove 

helm-remove:
	kubectl delete -f $(L1DIR)/rbac.yml

.PHONY: .PHONY helm-remove

traefik-install:
	KUBECONFIG=$(KUBECONFIG) helm install stable/traefik -n traefix -f traefik/config.yml --namespace kube-system

traefik-remove:
	helm del traefix --purge

.PHONY: .PHONY traefik-install traefik-remove 

kube-csi-install:
	$(MAKE) kube-csp-secret-install.$(CSP)
	$(KC) helm install $(L1DIR)/csi/$(CSP) -n csi-$(CSP)

kube-csi-remove: kube-csp-secret-remove
	$(KC) helm del csi-$(CSP) --purge

kube-csp-secret-install.%:
	$(eval csp := $(@:kube-csp-secret-install.%=%))
	$(MAKE) kube-csp-secret-install-$(csp)

kube-csp-secret-remove:
	$(KC) kubectl delete -f $(DATADIR)/db/config/csps/secrets/$(CSP).yml

.PHONY: .PHONY kube-csi-install kube-csi-install.% kube-csi-remove kube-csi-remove.% kube-csp-secret-install kube-csp-secret-remove

kube-csp-secret-install-packet:
	mkdir -p $(DATADIR)/db/config/csps/secrets/$(CSP)
	echo "{ \"apiKey\": \"$(PACKET_API_TOKEN)\", \"projectID\":\"$(PACKET_PROJECT_ID)\"}" > $(DBCFG)/csps/secrets/$(CSP)/cloud-sa.json
	$(KCTL) create --namespace $(KUBE_NAMESPACE) secret generic packet-cloud-config --from-file=$(DBCFG)/csps/secrets/$(CSP)/cloud-sa.json
.PHONY: .PHONY kube-csp-secret-install-packet
