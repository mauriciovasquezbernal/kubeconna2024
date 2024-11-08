#!/bin/bash

set -eoux pipefail

vagrant up
vagrant ssh -c "sudo /vagrant/provision.sh"
vagrant halt
vagrant package --output ig-kubecon-na-2024.box
