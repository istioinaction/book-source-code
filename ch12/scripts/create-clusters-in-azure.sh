#!/bin/bash

set -e

echo "== Create clusters =="
az group create --resource-group west-cluster-rg --location westus > /dev/null
az group create --resource-group east-cluster-rg --location eastus > /dev/null

az aks create --name west-cluster  \
              --resource-group west-cluster-rg \
              --node-count 1 \
              -s Standard_D2_v2 > /dev/null

az aks create --name east-cluster  \
              --resource-group east-cluster-rg \
              --node-count 1 \
              -s Standard_D3_v2 > /dev/null
echo "Done"
sleep 10

echo
echo "== Configure access to the cluster for kubectl =="
az aks get-credentials --resource-group west-cluster-rg --name west-cluster --overwrite-existing
az aks get-credentials --resource-group east-cluster-rg --name east-cluster --overwrite-existing
