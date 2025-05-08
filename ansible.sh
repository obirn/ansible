#!/bin/sh
ansible-playbook \
	-i inventory.yml \
	--ask-become-pass \
	playbooks/full.yml
