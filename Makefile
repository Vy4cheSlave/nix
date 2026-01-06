.PHONY: init
init:
	sudo nix run github:nix-darwin/nix-darwin -- switch --flake .#vch

.PHONY: update
update:
	sudo darwin-rebuild switch --flake ~/nix#vch

.PHONY: clean
clean:
	nix-collect-garbage -d