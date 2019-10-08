L2DIR ?= $(PWD)

prometheus-install:
	helm install stable/prometheus -f $(L2DIR)/prometheus.yml -n $(RELEASE)-metrics

prometheus-remove:
	helm del --purge $(RELEASE)-metrics

grafana-install:
	helm install stable/grafana -f $(L2DIR)/grafana.yml -n $(RELEASE)-status

grafana-remove:
	helm del --purge $(RELEASE)-status

.PHONY: .PHONY prometheus-install prometheus-remove grafana-install grafana-remove
