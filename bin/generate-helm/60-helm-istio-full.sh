DIRECTORY=$(cd `dirname $0` && pwd)

source $DIRECTORY/set-env.sh

helm template $ISTIO_RELEASE/install/kubernetes/helm/istio \
  --name istio \
  --namespace istio-system \
  --set gateways.enabled=true \
  --set security.enabled=true \
  --set global.mtls.enabled=false \
  --set galley.enabled=true \
  --set global.useMCP=true \
  --set sidecarInjectorWebhook.enabled=true \
  --set mixer.enabled=true \
  --set mixer.policy.enabled=true \
  --set mixer.telemetry.enabled=true \
  --set prometheus.enabled=true \
  --set grafana.enabled=true \
  --set tracing.enabled=true \
  --set kiali.enabled=true \
  --set pilot.sidecar=true  > $DIRECTORY/../../install/60-istio-full.yaml