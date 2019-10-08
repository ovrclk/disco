.EXPORT_ALL_VARIABLES:

BASEDIR 		?= $(CURDIR)
DATADIR 		= $(BASEDIR)/.data
KUBECONFIG	= $(DATADIR)/kubeconfig
K3S_VERSION = v0.9.0
MASTER_IP 	?= $(shell dig +short k1.ovrclk.net)
SSHUSER 		?= root
RELEASE 		?= kernel

setup:
	mkdir -p $(DATADIR)

clean:
	rm -r $(DATADIR)

kube-config: setup
	k3su install --ip $(MASTER_IP) --user $(SSHUSER) --skip-install --local-path $(KUBECONFIG) --k3s-version=$(K3S_VERSION)

kube-config-path:
	@echo $(KUBECONFIG)

checkaction:
	@echo "Are you sure? This action is not reversable [y/N] " && read ans && [ $${ans:-N} = y ]

.PHONY: .PHONY setup clean kube-config kube-config-path checkaction
