L1DIR ?= $(CURDIR)
CSP 	?= packet
KUBE_NAMESPACE = kube-system

layer1-install: kube-install helm-install kube-csi-install

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

kube-install: setup
	k3su install --ip $(MASTER_IP) --user $(SSHUSER) --local-path $(KUBECONFIG) --k3s-version=$(K3S_VERSION) #--k3s-extra-args '--no-deploy traefik'

kube-remove: checkaction
	ssh $(SSHUSER)@$(MASTER_IP) "k3s-uninstall.sh"
	rm $(KUBECONFIG)

.PHONY: .PHONY kube-install kube-remove 

helm-install:
	KUBECONFIG=$(KUBECONFIG) kubectl apply -f $(L1DIR)/helm.yml
	KUBECONFIG=$(KUBECONFIG) helm init --service-account tiller --upgrade --wait

helm-remove:
	kubectl delete -f $(L1DIR)/rbac.yml
	helm reset 

.PHONY: .PHONY helm-install helm-remove

traefik-install:
	KUBECONFIG=$(KUBECONFIG) helm install stable/traefik -n traefix -f traefik/config.yml --namespace kube-system

traefik-remove:
	helm del traefix --purge

.PHONY: .PHONY traefik-install traefik-remove 

kube-csp-install:
	KUBECONFIG=$(KUBECONFIG) kubectl apply --wait -f $(L1DIR)/$(CSP)/

kube-csp-remove:
	kubectl delete --wait -f $(L1DIR)/$(CSP)

.PHONY: .PHONY kube-csp-install kube-csp-remove 

kube-csp-secret-install:
	$(KC) kubectl apply --wait -f $(DATADIR)/csp-secret/$(CSP).yml

kube-csp-secret-remove:
	$(KC) kubectl delete -f $(DATADIR)/csp-secret/$(CSP).yml

kube-csi-install: kube-csp-secret-install
	$(KC) helm install $(L1DIR)/csi/$(CSP) -n csi-$(CSP)

kube-csi-remove: kube-csp-secret-remove
	$(KC) helm del csi-$(CSP) --purge

.PHONY: .PHONY kube-csi-install kube-csi-remove kube-csp-secret-install kube-csp-secret-remove
