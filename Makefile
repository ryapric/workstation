.PHONY: %

system-config:
	@bash ./system/_main.sh

dotfiles-link:
	@make -C ./dotfiles -s setup
