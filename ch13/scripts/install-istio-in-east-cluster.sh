#!/bin/bash

set -e

# Print commands using the flag '-v'
if [[ $* == *-v* ]]; then
  set -x
fi

ch12_dir=$(realpath `dirname "$BASH_SOURCE"`/../../ch12)

alias keast='kubectl --context="east-cluster"'
alias iwest='istioctl --context="west-cluster"'
alias ieast='istioctl --context="east-cluster"'

echo "== Create the istio-system namespace =="
keast create namespace istio-system || true

echo
echo "== Label the namespace with network metadata =="
keast label namespace istio-system topology.istio.io/network=east-network

echo
echo "== Install the Plugin CA Certificates =="
keast create secret generic cacerts -n istio-system \
  --from-file="${ch12_dir}"/certs/east-cluster/ca-cert.pem \
  --from-file="${ch12_dir}"/certs/east-cluster/ca-key.pem \
  --from-file="${ch12_dir}"/certs/root-cert.pem \
  --from-file="${ch12_dir}"/certs/east-cluster/cert-chain.pem

echo
echo "== Install the control plane =="
ieast install -y -f "${ch12_dir}"/controlplanes/cluster-east.yaml

echo
echo "== Install the east west gateway =="
ieast install -y -f "${ch12_dir}"/gateways/cluster-east-eastwest-gateway.yaml

echo
echo "== Expose services through the east west gateway =="
keast apply -n istio-system -f "${ch12_dir}"/gateways/expose-services.yaml

echo
echo "== Apply east-cluster remote secret in the west cluster =="
iwest x create-remote-secret --name="west-cluster" | keast apply -f -
