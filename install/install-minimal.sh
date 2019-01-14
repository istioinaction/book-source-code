#!/usr/bin/env bash

kubectl create -f catalog-service/catalog-svc.yml
kubectl create -f <(istioctl kube-inject catalog-service/catalog-deployment.yml)

kubectl create -f gateway-service/gateway-svc.yml
kubectl create -f <(istioctl kube-inject gateway-service/gateway-deployment.yml)


