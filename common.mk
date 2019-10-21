DATA_REPO 	= keybase://team/$(USER)/disco

HOST 				= sjc1.ovrclk.net
DOMAIN 			= $(HOST)
MASTER_IP 	= $(shell dig +short $(HOST))
DATADIR 		= $(BASEDIR)/data
KUBECONFIG	= $(DATADIR)/db/config/kube/$(HOST)
K3S_VERSION = v0.9.0
SSHUSER 		= root
RELEASE 		= kernel
KC					= KUBECONFIG=$(KUBECONFIG)
KCTL 				= $(KC) kubectl 

ALL_HOSTS =  $(shell cat $(DATADIR)/db/index/HOSTS)
GITCMD = git --git-dir $(DATADIR)/.git --work-tree $(DATADIR) 

# helpers
# a literal space.
space :=
space +=
comma := ,
# Joins elements of the list in arg 2 with the given separator.
#   1. Element separator.
#   2. The list.
join-with = $(subst $(space),$1,$(strip $2))

data-pull:
	[ -d "$(DATADIR)" ] || git clone $(DATA_REPO) $(DATADIR)
	cd $(DATADIR) && git pull --rebase origin master

data-push:
	[[ -z "$(shell $(GITCMD) status -s)" ]] || $(MAKE) data-commit-push

data-commit-push:
	$(GITCMD) add . \
		&& $(GITCMD) commit -asm "$$USER@$(shell hostname)" \
		&& $(GITCMD) $(DATADIR) push origin master

setup:
	mkdir -p $(DATADIR)/kube $(DATADIR)/providers

hosts:
	cat $(DATADIR)/hosts
	
clean:
	rm -r $(DATADIR)/*

kube-config: setup
	k3su install --ip $(MASTER_IP) --user $(SSHUSER) --skip-install --local-path $(KUBECONFIG) --k3s-version=$(K3S_VERSION)

kube-config-path:
	@echo $(KUBECONFIG)

checkaction:
	@echo "Are you sure? This action is not reversable [y/N] " && read ans && [ $${ans:-N} = y ]

showhost:
	@echo $(HOST)

showip:
	@echo $(MASTER_IP)

ssh:
	ssh -o StrictHostKeyChecking=no $(SSHUSER)@$(MASTER_IP)

.PHONY: .PHONY setup clean kube-config kube-config-path checkaction showip
