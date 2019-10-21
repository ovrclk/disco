DATA_REPO 	= keybase://team/akashnet/testnet
DATADIR 		= $(BASEDIR)/data
DB = $(DATADIR)/db
# index for common resources
DBIDX = $(DB)/index
DBCFG = $(DB)/config
DBKEY = $(DB)/keys

DB_NODES 			= $(shell cat $(DATADIR)/db/index/NODES)
DB_HOSTS 			= $(shell cat $(DATADIR)/db/index/HOSTS)
DB_ACCOUNTS 			= $(shell cat $(DATADIR)/db/index/ACCOUNTS)
DB_PROVIDERS 			= $(shell cat $(DATADIR)/db/index/PROVIDERS)

GITCMD = git --git-dir $(DATADIR)/.git --work-tree $(DATADIR) 

# danger
db-clean:
	rm -r $(DATADIR)/*

db-rebase:
	[ -d "$(DATADIR)" ] || git clone $(DATA_REPO) $(DATADIR)
	$(GITCMD) pull --rebase origin master

db-save: db-commit db-rebase db-push

db-push: 
	$(GITCMD) push origin master

db-commit:
	[[ -z "$(shell $(GITCMD) status -s)" ]] || $(GITCMD) add $(DATADIR) \
		|| $(GITCMD) commit -asm "$(USER)@$(shell hostname)"

setup:
	mkdir -p $(DB)/config/kube \
		$(DATADIR)/config/providers \
		$(DATADIR)/config/nodes \
		$(DBKEY)

# default host
HOST 				= sjc1.ovrclk.net
DOMAIN 			= $(HOST)
MASTER_IP 	= $(shell dig +short $(HOST))
KUBECONFIG	= $(DATADIR)/db/config/kube/$(HOST)
K3S_VERSION = v0.9.0
SSHUSER 		= root
RELEASE 		= kernel
KC					= KUBECONFIG=$(KUBECONFIG)
KCTL 				= $(KC) kubectl 

ALL_HOSTS =  $(shell cat $(DATADIR)/db/index/HOSTS)

# helpers
# a literal space.
space :=
space +=
comma := ,
# Joins elements of the list in arg 2 with the given separator.
#   1. Element separator.
#   2. The list.
join-with = $(subst $(space),$1,$(strip $2))

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
