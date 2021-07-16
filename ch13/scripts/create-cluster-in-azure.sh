#!/bin/bash

set -e

# Print commands using the flag '-v'
if [[ $* == *-v* ]]; then
  set -x
fi

echo "== Create cluster =="
az group create --resource-group west-cluster-rg --location westus > /dev/null

az aks create --name west-cluster  \
              --resource-group west-cluster-rg \
              --node-count 1 \
              -s Standard_D2_v2 > /dev/null

echo "Cluster created"
sleep 10

echo
echo "== Configure access to the cluster for kubectl =="
az aks get-credentials --resource-group west-cluster-rg --name west-cluster --overwrite-existing
