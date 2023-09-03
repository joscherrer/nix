.PHONY: all linux
TMPDIR := $(shell mktemp -d -p /tmp)
OS_NAME := $(shell uname -s | tr A-Z a-z)

all: $(OS_NAME)

fresh: EXTRA_ARGS += --recreate-lock-file
fresh: $(OS_NAME)

ifeq ($(OS_NAME), linux)
linux: linux-local
darwin: darwin-remote
else ifeq ($(OS_NAME), darwin)
linux: linux-remote
darwin: darwin-local
endif

linux-local:
	sudo nixos-rebuild switch --flake "$HOME/nix#bbrain-linux" $(EXTRA_ARGS)

darwin-local:
	darwin-rebuild switch --flake ~/dev/nix#bbrain-mbp $(EXTRA_ARGS)

linux-remote: EXTRA_ARGS += --fast --use-remote-sudo --target-host jscherrer@bbrain-linux --build-host jscherrer@bbrain-linux
linux-remote:
	TMPDIR=$(TMPDIR) nixos-rebuild switch --flake ~/dev/nix#bbrain-linux $(EXTRA_ARGS)

darwin-remote:
	@echo "Not implemented yet"

