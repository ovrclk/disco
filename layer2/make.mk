L2DIR 				?= $(PWD)
L2_NAMESPACE 	= monitoring
L2_DOMAIN 		= $(HOST)

layer2-install: helm-repo-update monitoring-ns-create prometheus-install grafana-install metrics-install

layer2-remove: prometheus-remove grafana-remove metrics-remove monitoring-ns-remove

layer2-install.%:
	$(eval host := $(@:layer2-install.%=%))
	$(MAKE) HOST=$(host) layer2-install || true

layer2-install-all:
	$(foreach host, $(ALL_HOSTS), $(MAKE) layer2-install.$(host))

layer2-remove.%:
	$(eval host := $(@:layer2-remove.%=%))
	$(MAKE) HOST=$(host) layer2-remove || true

layer2-remove-all:
	$(foreach host, $(ALL_HOSTS), $(MAKE) layer2-remove.$(host))

.PHONY: .PHONY helm-repo-update layer2-install layer2-remove layer2-install.% layer2-install-all layer2-remove.% layer2-remove-all layer2-check.% layer2-check

helm-repo-update:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	helm repo update

monitoring-ns-create:
	$(KCTL) create namespace $(L2_NAMESPACE) || true

monitoring-ns-remove:
	$(KCTL) delete namespace $(L2_NAMESPACE) || true

metrics-install:
	$(KC) helm upgrade --install --namespace $(L2_NAMESPACE) metrics-server stable/metrics-server

metrics-remove:
	$(KC) helm delete metrics-server

.PHONY: .PHONY metrics-install metrics-remove

prometheus-install:
	$(KC) helm upgrade --install --namespace $(L2_NAMESPACE) prometeus stable/prometheus -f $(L2DIR)/prometheus/values.yml \
		--set "server.ingress.hosts={metrics.$(L2_DOMAIN)}"

prometheus-remove:
	$(KC) helm delete prometheus

.PHONY: .PHONY prometheus-install prometheus-remove 

grafana-install:
	$(KC) helm upgrade --install --namespace $(L2_NAMESPACE) grafana stable/grafana -f $(L2DIR)/grafana/values.yml \
		--set "ingress.hosts={status.$(L2_DOMAIN)}"

grafana-remove:
	$(KC) helm delete grafana


.PHONY: .PHONY grafana-install grafana-remove

logdna-install:
	$(KC) kubectl create --namespace $(L2_NAMESPACE) secret generic logdna-agent-key --from-literal=logdna-agent-key=$(shell cat $(DATADIR)/db/config/csps/secrets/logdna.key)
	$(KC) kubectl apply --namespace $(L2_NAMESPACE) -f https://raw.githubusercontent.com/logdna/logdna-agent/master/logdna-agent-ds.yaml

logdna-remove:
	$(KC) kubectl delete --namespace $(L2_NAMESPACE) secret logdna-agent-key 
	$(KC) kubectl delete --namespace $(L2_NAMESPACE) -f https://raw.githubusercontent.com/logdna/logdna-agent/master/logdna-agent-ds.yaml

.PHONY: logdna-install logdna-remove
