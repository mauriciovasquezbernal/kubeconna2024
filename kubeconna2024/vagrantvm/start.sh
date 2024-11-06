#!/bin/bash

set -eoux pipefail

echo "importing box"
vagrant box add --name ig-kubecon-na-2024 ../ig-kubecon-na-2024.box
echo "starting vm"
vagrant up
echo "vm started, now use vagrant ssh to log into it"
