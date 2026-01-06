.PHONY: init
init:
	sudo nix run github:nix-darwin/nix-darwin -- switch --flake .#vch

.PHONY: update
update:
	sudo darwin-rebuild switch --flake ~/nix#vch

.PHONY: clean
clean:
	nix-collect-garbage -d

.PHONY: push
push:
	git add .
	@git commit -m "$(shell date -u '+%Y-[%m-%B]-[%d-%A] %H:%M')"
	git push origin main