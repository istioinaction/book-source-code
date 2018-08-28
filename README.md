ISTIO_PROXY_IMAGE=proxyv2

Example:

kubectl replace -f <(ISTIO_PROXY_IMAGE=proxyv2 istioctl kube-inject --debug -f install/gateway-service/gateway-deployment.yml)