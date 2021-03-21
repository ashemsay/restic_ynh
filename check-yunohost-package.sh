#!/bin/bash
vagrant up
vagrant ssh -c "lxd init --auto;/package_check/package_check.sh /restic_ynh"
vagrant halt
