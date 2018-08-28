#!/usr/bin/env bash

FROM=$(kubectl get pod | grep 'Running' | grep $1 | cut -d ' ' -f 1)
kubectl cp -c istio-proxy istioinaction/$FROM:opt/output.pcap /Users/ceposta/temp/output.pcap
