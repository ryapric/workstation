.PHONY: %

system-config:
	@bash ./system/_main.sh

dotfiles-link:
	@bash ./dotfiles/setup.sh
