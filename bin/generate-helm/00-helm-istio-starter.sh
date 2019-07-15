
DIRECTORY=$(cd `dirname $0` && pwd)

source $DIRECTORY/set-env.sh

helm template $ISTIO_RELEASE/install/kubernetes/helm/istio \
  --name istio \
  --namespace istio-system \
  --set gateways.enabled=false \
  --set security.enabled=false \
  --set global.mtls.enabled=false \
  --set galley.enabled=false \
  --set global.useMCP=false \
  --set sidecarInjectorWebhook.enabled=false \
  --set mixer.enabled=false \
  --set mixer.policy.enabled=false \
  --set mixer.telemetry.enabled=false \
  --set prometheus.enabled=false \
  --set grafana.enabled=false \
  --set tracing.enabled=false \
  --set kiali.enabled=false \
  --set pilot.sidecar=false  > $DIRECTORY/../../install/00-istio-starter.yaml