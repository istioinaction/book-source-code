#!/usr/bin/env bash

GRAFANA=$(kubectl -n istio-system get pod | grep -i running | grep grafana | cut -d ' ' -f 1)
kubectl port-forward -n istio-system $GRAFANA 8080:3000