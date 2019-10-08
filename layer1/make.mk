L1DIR ?= $(PWD)
KUBE_NAMESPACE ?= kube-system

layer1-install: kube-install helm-install csi-packet-install

layer1-remove: kube-remove 

.PHONY: .PHONY layer1-install layer1-remove

kube-install: setup
	k3su install --ip $(MASTER_IP) --user $(SSHUSER) --local-path $(KUBECONFIG) --k3s-version=$(K3S_VERSION)

kube-remove: checkaction
	ssh $(SSHUSER)@$(MASTER_IP) "k3s-uninstall.sh"

helm-install:
	kubectl apply -f $(L1DIR)/helm.yml
	helm init --service-account tiller

helm-remove:
	kubectl delete -f $(L1DIR)/rbac.yml
	helm reset 

kube-remove-system-traefik:
	kubectl delete deploy,sa,svc traefik --namespace=kube-system

.PHONY: .PHONY kube-install kube-remove kube-remove-system-traefik helm-install helm-remove

csi-packet-install:
	kubectl apply --wait -f $(L1DIR)/packet-secret.yml
	kubectl apply --wait -f $(L1DIR)/packet/

csi-packet-remove:
	kubectl delete --wait -f $(L1DIR)/packet

.PHONY: .PHONY csi-packet-install csi-packet-remove
