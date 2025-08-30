SHELL := /usr/bin/env bash

.PHONY: %

ansible_dir := ./system/ansible
ansible_cfg := $(ansible_dir)/ansible.cfg
main_playbook := $(ansible_dir)/main.yaml

export ANSIBLE_CONFIG=$(ansible_cfg)

system-config: ansible-lint
	ansible-playbook --skip-tags 'desktop' $(main_playbook)

system-config-desktop: ansible-lint
	ansible-playbook --tags 'desktop' $(main_playbook)

ansible-lint:
	ansible-lint ./system/ansible/*.yaml
	ansible-lint ./system/ansible/tasks/*.yaml

dotfiles:
	@make -C ./dotfiles-and-config -s setup

# Runs tests in Vagrant. In case of failures during iteration, this splits up
# the provisioning call into its own line so this target can be called multiple
# times as the results "cache"
test-run:
	vagrant up --no-provision
	vagrant provision
	vagrant reload

test-stop:
	vagrant destroy -f
