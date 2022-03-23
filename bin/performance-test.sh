#!/bin/bash

main(){
  ## Pass input args for initialization
  init_args "$@"

  SLEEP_POD=$(kubectl -n istioinaction get pod -l app=sleep -o jsonpath={.items..metadata.name} -n istioinaction | cut -d ' ' -f 1)

  PRE_PUSHES=$(kubectl exec -n istio-system deploy/istiod -- curl -s localhost:15014/metrics | grep pilot_xds_pushes | awk '{total += $2} END {print total}') 

  if [[ -z "$PRE_PUSHES" ]]; then
    echo "Failed to query Pilot Pushes from prometheus."
    echo "Have you installed prometheus as shown in chapter 7?"
    exit 1
  fi

  echo "Pre Pushes: $PRE_PUSHES"

  INDEX="0"
  while [[ $INDEX -lt $REPS ]]; do
    SERVICE_NAME="service-`openssl rand -hex 2`-$INDEX" 

    create_random_resource $SERVICE_NAME &
    sleep $DELAY
    INDEX=$[$INDEX+1]
  done

  ## Wait until the last item is distributed
  while [[ "$(curl --max-time .5 -s -o /dev/null -H "Host: $SERVICE_NAME.istioinaction.io" -w ''%{http_code}'' $GATEWAY/items)" != "200" ]]; do 
    # curl --max-time .5 -s -o /dev/null -H "Host: $SERVICE_NAME.istioinaction.io" $GATEWAY/items
    sleep .2
  done

  echo ==============

  sleep 10

  POST_PUSHES=$(kubectl exec -n istio-system deploy/istiod -- curl -s localhost:15014/metrics | grep pilot_xds_pushes | awk '{total += $2} END {print total}')

  echo
  
  LATENCY=$(kubectl -n istioinaction exec -it $SLEEP_POD -c sleep -- curl "$PROM_URL/api/v1/query" --data-urlencode "query=histogram_quantile(0.99, sum(rate(pilot_proxy_convergence_time_bucket[1m])) by (le))" | jq  '.. |."value"? | select(. != null) | .[1]' -r)

  echo "Push count:" `expr $POST_PUSHES - $PRE_PUSHES`
  echo "Latency in the last minute: `printf "%.2f\n" $LATENCY` seconds" 
}

create_random_resource() {
  SERVICE_NAME=$1
  cat <<EOF | kubectl apply -f -
---
kind: Gateway
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: $SERVICE_NAME
  namespace: $NAMESPACE
spec:
  servers:
    - hosts:
        - "$SERVICE_NAME.istioinaction.io"
      port:
        name: http
        number: 80
        protocol: HTTP
  selector:
    istio: ingressgateway
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: catalog
  name: $SERVICE_NAME
  namespace: $NAMESPACE
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 3000
  selector:
    app: catalog
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata: 
  name: $SERVICE_NAME
  namespace: $NAMESPACE
spec:
  hosts:
  - "$SERVICE_NAME.istioinaction.io"
  gateways:
  - "$SERVICE_NAME"
  http:
  - route:
    - destination:
        host: $SERVICE_NAME.istioinaction.svc.cluster.local
        port:
          number: 80
---
EOF
}

help() {
    cat <<EOF
Poor Man's Performance Test creates Services, Gateways and VirtualServices and measures Latency and Push Count needed to distribute the updates to the data plane.
       --reps         The number of services that will be created. E.g. --reps 20 creates services [0..19]. Default '20'
       --delay        The time to wait prior to proceeding with another repetition. Default '0'
       --gateway      URL of the ingress gateway. Defaults to 'localhost'
       --namespace    Namespace in which to create the resources. Default 'istioinaction'
       --prom-url     Prometheus URL to query metrics. Defaults to 'prom-kube-prometheus-stack-prometheus.prometheus:9090'
EOF
    exit 1
}

init_args() {
  while [[ $# -gt 0 ]]; do
      case ${1} in
          --reps)
              REPS="$2"
              shift
              ;;
          --delay)
              DELAY="$2"
              shift
              ;;
          --gateway)
              GATEWAY="$2"
              shift
              ;;
          --namespace)
              NAMESPACE="$2"
              shift
              ;;
          --prom-url)
              PROM_URL="$2"
              shift
              ;;
          *)
              help
              ;;
      esac
      shift
  done

  [ -z "${REPS}" ] &&  REPS="20"
  [ -z "${DELAY}" ] &&  DELAY=0
  [ -z "${GATEWAY}" ] &&  GATEWAY=localhost
  [ -z "${NAMESPACE}" ] &&  NAMESPACE=istioinaction
  [ -z "${PROM_URL}" ] &&  PROM_URL="prom-kube-prometheus-stack-prometheus.prometheus.svc.cluster.local:9090"
}

main "$@"
