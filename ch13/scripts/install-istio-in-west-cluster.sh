#!/bin/bash

set -e

# Print commands using the flag '-v'
if [[ $* == *-v* ]]; then
  set -x
fi

ch12_dir=$(realpath `dirname "$BASH_SOURCE"`/../../ch12)

alias kwest='kubectl --context="west-cluster"'
alias iwest='istioctl --context="west-cluster"'
alias ieast='istioctl --context="east-cluster"'

echo "== Create the istio-system namespace =="
kwest create namespace istio-system 

echo
echo "== Label the namespace with network metadata =="
kwest label namespace istio-system topology.istio.io/network=west-network

echo
echo "== Install the Plugin CA Certificates =="
kwest create secret generic cacerts -n istio-system \
  --from-file="${ch12_dir}"/certs/west-cluster/ca-cert.pem \
  --from-file="${ch12_dir}"/certs/west-cluster/ca-key.pem \
  --from-file="${ch12_dir}"/certs/root-cert.pem \
  --from-file="${ch12_dir}"/certs/west-cluster/cert-chain.pem

echo
echo "== Install the control plane =="
iwest install -y -f "${ch12_dir}"/controlplanes/cluster-west.yaml

echo
echo "== Install the east west gateway =="
iwest install -y -f "${ch12_dir}"/gateways/cluster-west-eastwest-gateway.yaml

echo
echo "== Expose services through the east west gateway =="
kwest apply -n istio-system -f "${ch12_dir}"/gateways/expose-services.yaml

echo
echo "== Apply east-cluster remote secret in the west cluster =="
ieast x create-remote-secret --name="east-cluster" | kwest apply -f -
