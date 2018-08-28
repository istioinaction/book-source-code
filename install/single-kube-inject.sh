#!/usr/bin/env bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
kubectl apply -f <(istioctl kube-inject -f "$ROOT_DIR/$1-service/$1-deployment.yaml")
