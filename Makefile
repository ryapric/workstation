SHELL := /usr/bin/env bash

RUN = uv run

.PHONY: %

default: ansible-init system-config system-config-desktop

ansible_dir := ./system/ansible
ansible_cfg := $(ansible_dir)/ansible.cfg
main_playbook := $(ansible_dir)/main.yaml

export ANSIBLE_CONFIG = $(ansible_cfg)

ansible-init:
	$(RUN) ansible-galaxy install -r ./system/ansible/requirements.yaml

system-config: ansible-lint
	$(RUN) ansible-playbook --skip-tags 'desktop' $(main_playbook)

system-config-desktop: ansible-lint
	$(RUN) ansible-playbook --tags 'desktop' $(main_playbook)

ansible-lint:
	$(RUN) ansible-lint ./system/ansible/*.yaml
	$(RUN) ansible-lint ./system/ansible/tasks/*.yaml

# NOTE: this is ran in the Ansible Playbook as well
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
