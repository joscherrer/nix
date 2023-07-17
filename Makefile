.PHONY: all linux
TMPDIR := $(shell mktemp -d -p /tmp)

all:

linux:
	TMPDIR=$(TMPDIR) nixos-rebuild --fast --target-host jscherrer@192.168.1.175 --build-host jscherrer@192.168.1.175 switch --flake '/Users/jscherrer/dev/nix#bbrain-linux' --use-remote-sudo $(EXTRA_ARGS)

mbp:
	darwin-rebuild switch --flake ~/dev/nix#bbrain-mbp