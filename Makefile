.PHONY: all linux darwin linux-local darwin-local linux-remote darwin-remote commit-lockfile
TMPDIR := $(shell mktemp -d -p /tmp)
OS_NAME := $(shell uname -s | tr A-Z a-z)

all: $(OS_NAME) gh-copilot

fresh: flake-update $(OS_NAME) gh-copilot commit-lockfile

flake-update:
	nix flake update

ifeq ($(OS_NAME), linux)
linux: linux-local
darwin: darwin-remote
else ifeq ($(OS_NAME), darwin)
linux: linux-remote
darwin: darwin-local
endif

linux-local:
	sudo nixos-rebuild switch --flake "$(HOME)/dev/nix#bbrain-linux" $(EXTRA_ARGS)

darwin-local:
	darwin-rebuild switch --flake ~/dev/nix#bbrain-mbp $(EXTRA_ARGS)

linux-remote: EXTRA_ARGS += --fast --use-remote-sudo --target-host jscherrer@bbrain-linux --build-host jscherrer@bbrain-linux
linux-remote:
	TMPDIR=$(TMPDIR) nixos-rebuild switch --flake ~/dev/nix#bbrain-linux $(EXTRA_ARGS)

darwin-remote:
	@echo "Not implemented yet"

commit-lockfile:
	git add flake.lock
	git diff-index --quiet HEAD flake.lock || git commit --only flake.lock -m "Update flake.lock"
	git push

gh-copilot:
	gh auth status --hostname github.com || gh auth login --hostname github.com
	gh extension install github/gh-copilot

image:
	podman build -t nix-bbrain .

wsl:
	sudo nixos-rebuild switch --flake "$(PWD)/#jo-home" $(EXTRA_ARGS)

alpine:
	podman build -t alpine-bbrain -f alpine.Containerfile .

jumbo:
	sudo nixos-rebuild switch --flake "/root/nix#jumbo" $(EXTRA_ARGS)

rds:
	sudo nixos-rebuild switch --flake "$(PWD)/#rds" $(EXTRA_ARGS)

utm:
	sudo nixos-rebuild switch --flake "$(PWD)/#bbrain-utm" $(EXTRA_ARGS)
