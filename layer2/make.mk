L2DIR 				?= $(PWD)
L2_NAMESPACE 	= monitoring
L2_DOMAIN 		= $(HOST)

layer2-install: monitoring-ns-create prometheus-install grafana-install metrics-install

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

.PHONY: .PHONY layer2-install layer2-remove layer2-install.% layer2-install-all layer2-remove.% layer2-remove-all layer2-check.% layer2-check

monitoring-ns-create:
	$(KCTL) create namespace $(L2_NAMESPACE) || true

monitoring-ns-remove:
	$(KCTL) delete namespace $(L2_NAMESPACE) || true

metrics-install:
	$(KC) helm install --namespace $(L2_NAMESPACE) stable/metrics-server -n metrics-server 

metrics-remove:
	$(KC) helm del --purge metrics-server

.PHONY: .PHONY metrics-install metrics-remove

prometheus-install:
	$(KC) helm install --namespace $(L2_NAMESPACE) stable/prometheus -f $(L2DIR)/prometheus/values.yml -n prometheus \
		--set "server.ingress.hosts={metrics.$(L2_DOMAIN)}"

prometheus-remove:
	$(KC) helm del --purge prometheus

.PHONY: .PHONY prometheus-install prometheus-remove 

grafana-install:
	$(KC) helm install --namespace $(L2_NAMESPACE) stable/grafana -f $(L2DIR)/grafana/values.yml -n grafana \
		--set "ingress.hosts={status.$(L2_DOMAIN)}"

grafana-remove:
	$(KC) helm del --purge grafana

.PHONY: .PHONY grafana-install grafana-remove
