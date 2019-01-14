#!/usr/bin/env bash

TRACING=$(kubectl -n istio-system get pod | grep -i running | grep istio-tracing | cut -d ' ' -f 1)
kubectl port-forward -n istio-system $TRACING 8181:16686