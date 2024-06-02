SHELL := /usr/bin/env bash

.PHONY: %

ansible_dir := ./system/ansible
ansible_cfg := $(ansible_dir)/ansible.cfg
main_playbook := $(ansible_dir)/main.yaml

export ANSIBLE_CONFIG=$(ansible_cfg)

system-config:
	ansible-lint $(main_playbook)
	ansible-playbook --skip-tags 'desktop-only' $(main_playbook)

system-config-desktop-only:
	ansible-playbook --tags 'desktop-only' $(main_playbook)

dotfiles-setup:
	@make -C ./dotfiles -s setup

# Runs tests in Vagrant. In case of failures during iteration, this splits up
# the provisioning call into its own line so this target can be called multiple
# times as the results "cache"
test-run:
	vagrant up --no-provision
	vagrant provision
	vagrant reload

test-stop:
	vagrant destroy -f
