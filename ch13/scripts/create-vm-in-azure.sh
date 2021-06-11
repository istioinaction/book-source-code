#!/bin/bash

set -e

# Print commands using the flag '-v'
if [[ $* == *-v* ]]; then
  set -x
fi

keys_dir=`dirname "$BASH_SOURCE"`/../keys

echo "== Create the resource group =="
az group create --resource-group west-cluster-rg --location westus

echo
echo "== Create the Virtual machine =="
istioc
echo
echo "== Open application port 8080 =="
az vm open-port \
    --resource-group west-cluster-rg \
    --name forum-vm \
    --port 8080 --verbose
