#!/bin/bash
vagrant up
vagrant ssh -c "/package_check/package_check.sh /restic_ynh"
