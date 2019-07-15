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
  --set mixer.enabled=true \
  --set mixer.policy.enabled=true \
  --set mixer.telemetry.enabled=true \
  --set prometheus.enabled=true \
  --set grafana.enabled=false \
  --set tracing.enabled=false \
  --set kiali.enabled=false \
  --set pilot.sidecar=true  > $DIRECTORY/../../install/50-istio-almost-full.yaml