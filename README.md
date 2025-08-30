# Ryan's workstation initializer

This repo houses a set of utilities to initialize & keep up-to-date a portable Debian-based
developer workstation configuration, from system utilities to dotfile management.

This is literally just for me, not you, so dont't @ me about how it's set up.

## Requirements

* [uv](https://astral.sh/uv)

## How to use

The default Make target will run the Ansible Playbooks needed for setting up a desktop system. So,
just running `make` will do all that. At the time of this writing, this will also configure the
dotfile etc. placement on the host.

## How to update

* Any new system configuration needs to go somewhere appropriate under `system/ansible`. The
  `main.yaml` file should only set vars, and run tasks (found broken out in `system/ansible/tasks`)

* New dotfiles or other configuration files go in the `dotfiles-and-config/` directory. Anything you
  add needs to be reflected in the `map.txt` file in that directory, in order to specify what to do
  with the file. The placement is ultimately handled by the `setup.sh` script in the same directory.
