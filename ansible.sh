#!/bin/sh
ansible-playbook \
	--ask-become-pass \
	playbooks/full.yml
