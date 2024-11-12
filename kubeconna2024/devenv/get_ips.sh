#!/bin/bash

set -eoux pipefail

# get public IPs for all VMs in the subscription and write to file
az vm list-ip-addresses --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -o tsv > ips.txt
