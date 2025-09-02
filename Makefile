SHELL := /usr/bin/env bash

RUN = mise exec -- uv run

.PHONY: %

default: ansible-init ansible-lint core shell-extras

ansible_dir := ./system/ansible
ansible_cfg := $(ansible_dir)/ansible.cfg
main_playbook := $(ansible_dir)/main.yaml

export ANSIBLE_CONFIG = $(ansible_cfg)

ansible-init:
	$(RUN) ansible-galaxy install -r $(ansible_dir)/requirements.yaml

ansible-lint:
	$(RUN) ansible-lint $(ansible_dir)/*.yaml
	$(RUN) ansible-lint $(ansible_dir)/tasks/*.yaml

debian-unstable:
	$(RUN) ansible-playbook --tags 'debian-unstable' $(main_playbook)

core:
	$(RUN) ansible-playbook --tags 'core' $(main_playbook)

desktop:
	$(RUN) ansible-playbook --tags 'desktop' $(main_playbook)

shell-extras:
	$(RUN) ansible-playbook --tags 'shell-extras' $(main_playbook)

# home-server:
# 	$(RUN) ansible-playbook --tags 'home-server' $(main_playbook)

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
