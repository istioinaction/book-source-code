 DIRECTORY=$(cd `dirname $0` && pwd)

source $DIRECTORY/set-env.sh
 
 helm template $ISTIO_RELEASE/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system > $DIRECTORY/../../install/crds.yaml