#!/usr/bin/env bash

kubectl create -f cart-service/cart-svc.yml
kubectl create -f <(istioctl kube-inject cart-service/cart-deployment.yml)

kubectl create -f catalog-service/catalog-svc.yml
kubectl create -f <(istioctl kube-inject catalog-service/catalog-deployment.yml)

kubectl create -f gateway-service/gateway-svc.yml
kubectl create -f <(istioctl kube-inject gateway-service/gateway-deployment.yml)

kubectl create -f inventory-service/inventory-svc.yml
kubectl create -f <(istioctl kube-inject inventory-service/inventory-deployment.yml)

kubectl create -f coolstore-web-ui/coolstore-web-ui-svc.yml
kubectl create -f <(istioctl kube-inject coolstore-web-ui-service/coolstore-web-ui-deployment.yml)

# Should install keycloak with istio also!
