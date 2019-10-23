# DISCO Makefile
#
# Please read getting-started.md before using DISCO
#
BASEDIR = $(PWD)
include common.mk

L0DIR = $(BASEDIR)/layer0
include layer0/make.mk

L1DIR = $(BASEDIR)/layer1
include layer1/make.mk

L2DIR = $(BASEDIR)/layer2
include layer2/make.mk

L3DIR = $(BASEDIR)/layer3
include layer3/make.mk
