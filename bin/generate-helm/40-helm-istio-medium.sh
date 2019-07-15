DIRECTORY=$(cd `dirname $0` && pwd)

source $DIRECTORY/set-env.sh

helm template $ISTIO_RELEASE/install/kubernetes/helm/istio \
  --name istio \
  --namespace istio-system \
  --set gateways.enabled=true \
  --set security.enabled=true \
  --set global.mtls.enabled=false \
  --set galley.enabled=false \
  --set global.useMCP=false \
  --set sidecarInjectorWebhook.enabled=true \
  --set mixer.enabled=false \
  --set mixer.policy.enabled=false \
  --set mixer.telemetry.enabled=false \
  --set prometheus.enabled=true \
  --set grafana.enabled=true \
  --set tracing.enabled=false \
  --set kiali.enabled=false \
  --set pilot.sidecar=true  > $DIRECTORY/../../install/40-istio-medium.yaml