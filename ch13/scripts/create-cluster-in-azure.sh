#!/bin/bash

set -e

echo "== Create cluster =="
az group create --resource-group west-cluster-rg --location westus > /dev/null

# // To DO this command requires: --generate-ssh-keys or making use of the keys in the keys dir
az aks create --name west-cluster  \
              --resource-group west-cluster-rg \
              --node-count 1 \
              -s Standard_D2_v2 > /dev/null

echo "Cluster created"
sleep 10

echo
echo "== Configure access to the cluster for kubectl =="
az aks get-credentials --resource-group west-cluster-rg --name west-cluster --overwrite-existing
