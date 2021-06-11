#!/bin/bash

set -e

# Print commands using the flag '-v'
if [[ $* == *-v* ]]; then
  set -x
fi

ch12_dir=$(realpath `dirname "$BASH_SOURCE"`/../../ch12)
alias keast='kubectl --context="east-cluster"'

echo "== Create istioinaction namespace and label for sidecar injection =="
keast create ns istioinaction
keast label namespace istioinaction istio-injection=enabled

echo
echo "== Deploy catalog deployment and service =="
keast -n istioinaction apply -f "${ch12_dir}"/catalog.yaml
