#!/bin/bash

set -ex

# Set variables
RESOURCE_GROUP="contribfest-rg-$1"
LOCATION="EastUS"
VM_NAME="contributest-vm"
VM_SIZE="Standard_D4ads_v5"
IMAGE="Ubuntu2204"
ADMIN_USERNAME="iguser"
#ADMIN_PASSWORD="InspektorGadget642!"
ADMIN_PASSWORD=$(tr </dev/urandom -dc 'A-Za-z0-9!@#$%&*_-' | head -c12 || true) # Generate a random password
VNET_NAME="MyVNet"
SUBNET_NAME="MySubnet"
NIC_NAME="MyNIC"
PUBLIC_IP_NAME="MyPublicIP"
NSG_NAME="MyNSG"

# Step 1: Create a resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Step 2: Create a virtual network and subnet
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix '10.0.0.0/16' \
  --subnet-name $SUBNET_NAME \
  --subnet-prefix 10.0.1.0/24

# Step 3: Create a network security group and rule (optional)
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowSSH \
  --protocol tcp \
  --priority 1000 \
  --destination-port-range 22 \
  --access Allow \
  --direction Inbound

# Step 4: Create a public IP address
az network public-ip create \
  --resource-group $RESOURCE_GROUP \
  --name $PUBLIC_IP_NAME \
  --allocation-method Static

# Step 5: Create a network interface
az network nic create \
  --resource-group $RESOURCE_GROUP \
  --name $NIC_NAME \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --network-security-group $NSG_NAME \
  --public-ip-address $PUBLIC_IP_NAME

# Step 6: Create the VM
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --size $VM_SIZE \
  --image $IMAGE \
  --admin-username $ADMIN_USERNAME \
  --admin-password $ADMIN_PASSWORD \
  --nics $NIC_NAME

az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 22,3000,9090

#echo "VM $VM_NAME has been created successfully!"

IP_ADDRESS=$(az network public-ip show -g $RESOURCE_GROUP --name $PUBLIC_IP_NAME | jq -r  '.ipAddress')
#echo "IP address is $IP_ADDRESS"

sshpass -p $ADMIN_PASSWORD ssh -o StrictHostKeyChecking=no $ADMIN_USERNAME@$IP_ADDRESS 'bash -s' < provision.sh
sshpass -p $ADMIN_PASSWORD ssh -o StrictHostKeyChecking=no $ADMIN_USERNAME@$IP_ADDRESS 'bash -s' < port_forward.sh & > /dev/null 2>&1

echo "ssh $ADMIN_USERNAME@$IP_ADDRESS # password $ADMIN_PASSWORD" >> ssh.txt
