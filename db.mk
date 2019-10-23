# Config database setup, see getting-started.md for details
#
DATA_REPO ?= keybase://team/$(TEAM)/$(STACK)
DATADIR   ?= $(BASEDIR)/data
DB        ?= $(DATADIR)/db

DBIDX        := $(DB)/index
DBCFG        := $(DB)/config
DBKEY        := $(DB)/keys

# Indexes for common resources
#
DB_NODES     := $(shell [ -f $(DATADIR)/db/index/NODES ] && cat $(DATADIR)/db/index/NODES)
DB_HOSTS     := $(shell [ -f $(DATADIR)/db/index/HOSTS ] && cat $(DATADIR)/db/index/HOSTS)
DB_ACCOUNTS  := $(shell [ -f $(DATADIR)/db/index/ACCOUNTS ] && cat $(DATADIR)/db/index/ACCOUNTS)
DB_PROVIDERS := $(shell [ -f $(DATADIR)/db/index/PROVIDERS ] && cat $(DATADIR)/db/index/PROVIDERS)

STACK_ZONE   := $(shell [ -f $(DATADIR)/db/index/STACK_ZONE ] && cat $(DBIDX)/STACK_ZONE)
MACHINE_ZONE := $(shell [ -f $(DATADIR)/db/index/MACHINE_ZONE ] &&  cat $(DBIDX)/MACHINE_ZONE)

GITCMD = git --git-dir $(DATADIR)/.git --work-tree $(DATADIR) 

db-save: db-commit db-rebase db-push

db-setup: 
	git clone $(DATA_REPO) $(DATADIR)
	mkdir -p $(DBIDX) $(DBCFG)/providers $(DBCFG)/nodes $(DBKEY)

# Resets the DB, use with caution
#
db-clean:
	@echo "Are you sure? This action is reversable with only with git reset [y/N] " && read ans && [ $${ans:-N} = y ]
	rm -r $(DATADIR)/*

# Rebases the DB with remote, use with caution
db-rebase:
	[ -d "$(DATADIR)" ] || git clone $(DATA_REPO) $(DATADIR)
	$(GITCMD) pull --rebase origin master

db-push: 
	$(GITCMD) push origin master

db-commit:
	[[ -z "$(shell $(GITCMD) status -s)" ]] || $(GITCMD) add $(DATADIR) \
		&& $(GITCMD) commit -asm "$(USER)@$(shell hostname)"
