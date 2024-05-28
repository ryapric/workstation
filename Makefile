.PHONY: %

system-config:
	@bash ./system/_main.sh

dotfiles-setup:
	@make -C ./dotfiles -s setup

test-run:
	vagrant up && vagrant reload

test-stop:
	vagrant destroy -f
