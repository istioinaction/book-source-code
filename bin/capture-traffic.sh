#!/usr/bin/env bash

#function ctrl_c() {
#    echo "Cleaning up...$pid"
    #kubectl cp -c istio-proxy istioinaction/$FROM:opt/output.pcap /Users/ceposta/temp/output.pcap
#}

# trap ctrl-c and call ctrl_c()
#trap ctrl_c SIGINT


FROM=$(kubectl get pod | grep 'Running' | grep $1 | cut -d ' ' -f 1)
TO=$(kubectl get pod | grep 'Running' | grep $2 | cut -d ' ' -f 1)

TO_IP=$(kubectl get pod -o wide | grep $2 | awk '{ print $6 }')




# might come back to this; figure out how to automatically patch the deployment
#kubectl patch deployment $(kubectl get deploy | grep $FROM | cut -d ' ' -f 1) --type=json -p='[{"op": "replace", "path": "/spec/template/spec/containers/1/securityContext/readOnlyRootFilesystem", "value":"false"}]'
#kubectl patch deployment patch-demo --patch '{"spec": {"template": {"spec": {"containers": [{"name": "istio-proxy","securityContext": {"readOnlyRootFilesystem": "0"}}]}}}}'


echo "IP address of $TO is $TO_IP"

kubectl exec -it $FROM -c istio-proxy -- sh -c 'sudo rm -f /opt/output*.*  > /dev/null 2>&1'
kubectl exec -it  $FROM  -c istio-proxy -- sh -c "sudo tcpdump -i eth0 '((tcp) and (net $TO_IP))' -w /opt/output.pcap"
