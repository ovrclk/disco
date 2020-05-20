include $(BASEDIR)/env.mk
include $(BASEDIR)/db.mk

setup: db-setup

# The first host in the index 
# is the default host
#
HOST        := $(shell [ -f $(DBIDX)/HOSTS ] && cat $(DBIDX)/HOSTS | head -1)
DOMAIN      := $(HOST)
MASTER_IP   ?= $(shell dig +short $(HOST))
KUBECONFIG  := $(DATADIR)/db/config/kube/$(HOST)
K3S_VERSION := v0.9.0
SSHUSER     := root
RELEASE     := kernel
KC          := KUBECONFIG=$(KUBECONFIG)
KCTL        := $(KC) kubectl
SSH_KEY     ?= $(HOME)/.ssh/id_rsa

ALL_HOSTS =  $(shell [ -f $(DBIDX)/HOSTS ] && cat $(DBIDX)/HOSTS)

# helpers
# a literal space.
space :=
space +=
comma := ,
# Joins elements of the list in arg 2 with the given separator.
#   1. Element separator.
#   2. The list.
join-with = $(subst $(space),$1,$(strip $2))

kube-config: kube-config-path
	k3sup install --ip $(MASTER_IP) --user $(SSHUSER) --ssh-key $(SSH_KEY) --skip-install --local-path $(KUBECONFIG) --k3s-version=$(K3S_VERSION)

kube-config-path:
	@mkdir -p $(DBCFG)/kube
	@echo $(KUBECONFIG)

checkaction:
	@echo "Are you sure? This action is not reversable [y/N] " && read ans && [ $${ans:-N} = y ]

showhost:
	@echo $(HOST)

showip:
	@echo $(MASTER_IP)

ssh:
	ssh -o StrictHostKeyChecking=no $(SSHUSER)@$(MASTER_IP)

hosts:
	@echo $(DB_HOSTS)

.PHONY: .PHONY setup clean kube-config kube-config-path checkaction showip
