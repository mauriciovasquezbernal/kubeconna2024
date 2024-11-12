#!/bin/bash

# Get a list of resource groups that start with 'contribfest-rg-'
resource_groups=$(az group list --query "[?starts_with(name, 'contribfest-rg-')].name" -o tsv)

# Loop through each resource group and delete it
for rg in $resource_groups
do
    echo "Deleting resource group: $rg"
    az group delete --name "$rg" --yes --no-wait
done

echo "Resource group deletion initiated for all matching resource groups."
