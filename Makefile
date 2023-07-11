.PHONY: all linux

all:

linux:
	ssh jscherrer@192.168.1.90 "mkdir -p /home/jscherrer/dev/nix"
	rsync -avz --exclude '.git/' ./ jscherrer@192.168.1.90:/home/jscherrer/dev/nix
	ssh jscherrer@192.168.1.90 "sudo nixos-rebuild switch --flake /home/jscherrer/dev/nix#bbrain-linux"

mbp:
	darwin-rebuild switch --flake ~/dev/nix#bbrain-mbp