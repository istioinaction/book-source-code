#!/usr/bin/env bash

URL=$(minikube ip $@):$(kubectl -n istio-system get service istio-ingressgateway  -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
while true; do curl $URL/api/products; sleep .5; done