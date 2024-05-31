.PHONY: %

ansible_dir := ./system/ansible
ansible_cfg := $(ansible_dir)/ansible.cfg
debian_unstable_playbook := $(ansible_dir)/debian-unstable.yaml
main_playbook := $(ansible_dir)/main.yaml

export ANSIBLE_CONFIG=$(ansible_cfg)

system-config:
	ansible-lint $(debian_unstable_playbook)
	ansible-playbook $(debian_unstable_playbook)
	ansible-lint $(main_playbook)
	ansible-playbook $(main_playbook)

dotfiles-setup:
	@make -C ./dotfiles -s setup

test-run:
	vagrant up && vagrant reload

test-stop:
	vagrant destroy -f
