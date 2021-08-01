#!/bin/bash

set -e

# Print commands using the flag '-v'
if [[ $* == *-v* ]]; then
  set -x
fi

keys_dir=`dirname "$BASH_SOURCE"`/../keys
chmod 0600 "${keys_dir}"/id_rsa

echo "== Create the resource group =="
az group create --resource-group west-cluster-rg --location westus

echo
echo "== Create the Virtual machine =="
az vm create \
    --resource-group west-cluster-rg \
    --name forum-vm \
    --image 'Canonical:UbuntuServer:18.04-LTS:18.04.202105120' \
    --admin-username azureuser \
    --ssh-key-value "${keys_dir}"/id_rsa.pub \
    --size Standard_D1_v2

echo
echo "== Open application port 8080 =="
az vm open-port \
    --resource-group west-cluster-rg \
    --name forum-vm \
    --port 8080 --verbose
