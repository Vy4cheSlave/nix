.PHONY: init
init:
	sudo nix run github:nix-darwin/nix-darwin -- switch --flake .#vch

DARWIN_FLAKE ?= .\#vch
# Resilient cache list:
# - aseipp-nix-cache.* is documented by NixOS Fastly maintainers as an alternative cache front-end.
# - cache.nixos.org remains the primary official cache.
# - install.determinate.systems is used by Determinate Nix setups.
NIX_SUBSTITUTERS ?= https://cache.nixos.org https://aseipp-nix-cache.global.ssl.fastly.net https://install.determinate.systems
NIX_NETWORK_OPTIONS ?= \
	--option substituters "$(NIX_SUBSTITUTERS)" \
	--option connect-timeout 60 \
	--option stalled-download-timeout 1200 \
	--option download-attempts 10 \
	--option fallback true

.PHONY: update
update:
# 	sudo darwin-rebuild switch --flake "$(DARWIN_FLAKE)" $(NIX_NETWORK_OPTIONS)
	sudo darwin-rebuild switch --flake ~/nix#vch

.PHONY: clean-dry
clean-dry:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d --dry-run

.PHONY: clean
clean:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d
	sudo nix-collect-garbage -d

.PHONY: push
push:
	git add .
	@git commit -m "$(shell date -u '+%Y-[%m-%B]-[%d-%A] %H:%M')"
	git push origin main