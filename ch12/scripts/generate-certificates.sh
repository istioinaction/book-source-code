#!/bin/bash

set -ex

cert_dir=`dirname "$BASH_SOURCE"`/../certs

echo "Clean up contents of dir './chapter12/certs'"
rm -rf ${cert_dir}

echo "Generating new certificates"
mkdir -p ${cert_dir}/west-cluster
mkdir -p ${cert_dir}/east-cluster

if ! [ -x "$(command -v step)" ]; then
  echo 'Error: Install the smallstep cli (https://github.com/smallstep/cli)'
  exit 1
fi

step certificate create root.istio.in.action ${cert_dir}/root-cert.pem ${cert_dir}/root-ca.key \
  --profile root-ca --no-password --insecure --san root.istio.in.action \
  --not-after 87600h --kty RSA 

step certificate create west.intermediate.istio.in.action ${cert_dir}/west-cluster/ca-cert.pem ${cert_dir}/west-cluster/ca-key.pem --ca ${cert_dir}/root-cert.pem --ca-key ${cert_dir}/root-ca.key --profile intermediate-ca --not-after 87600h --no-password --insecure --san west.intermediate.istio.in.action --kty RSA 
step certificate create east.intermediate.istio.in.action ${cert_dir}/east-cluster/ca-cert.pem ${cert_dir}/east-cluster/ca-key.pem --ca ${cert_dir}/root-cert.pem --ca-key ${cert_dir}/root-ca.key --profile intermediate-ca --not-after 87600h --no-password --insecure --san east.intermediate.istio.in.action --kty RSA 

cat ${cert_dir}/west-cluster/ca-cert.pem ${cert_dir}/root-cert.pem > ${cert_dir}/west-cluster/cert-chain.pem
cat ${cert_dir}/east-cluster/ca-cert.pem ${cert_dir}/root-cert.pem > ${cert_dir}/east-cluster/cert-chain.pem
