#!/bin/bash

set -e

# Print commands using the flag '-v'
if [[ $* == *-v* ]]; then
  set -x
fi

ch12_dir=$(realpath `dirname "$BASH_SOURCE"`/../../ch12)
alias kwest='kubectl --context="west-cluster"'

echo "== Create istioinaction namespace and label for sidecar injection =="
kwest create ns istioinaction
kwest label namespace istioinaction istio-injection=enabled

echo
echo "== Deploy webapp deployment, service, gateway, and virtual service =="
kwest -n istioinaction apply -f "${ch12_dir}"/webapp-deployment-svc.yaml
kwest -n istioinaction apply -f "${ch12_dir}"/webapp-gw-vs.yaml

echo
echo "== Deploy a stub service for the catalog workload =="
kwest -n istioinaction apply -f "${ch12_dir}"/catalog-svc.yaml
