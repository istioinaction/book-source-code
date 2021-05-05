MINIKUBE := $(shell command -v minikube)


#----------------------------------------------------------------------------------
# Deploy services
#----------------------------------------------------------------------------------



.PHONY: ingress-url
ingress-url:
ifdef MINIKUBE
	@echo $(shell kubectl get pod -n istio-system -l istio=ingressgateway -o jsonpath='{.items[0].status.hostIP}'):$(shell kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
endif
# docker-for-desktop uses localhost
ifndef MINIKUBE 
	@echo "localhost"
endif
# ToDo add option when using cloud to use the external service
# kubectl get svc istio-ingressgateway -o jsonpath="{.status.loadBalancer.ingress[0].ip}"

.PHONY: ingress-pod
ingress-pod:
	@echo $(shell kubectl get pod -l app=istio-ingressgateway -o jsonpath={.items..metadata.name} -n istio-system)

.PHONY: apigateway-pod
apigateway-pod:
	@echo $(shell kubectl get pod -l app=apigateway -o jsonpath={.items..metadata.name} -n istioinaction)

.PHONY: catalog-pod
catalog-pod:
	@echo $(shell kubectl get pod -l app=catalog -o jsonpath={.items..metadata.name} -n istioinaction | cut -d ' ' -f 1)



.PHONY: chapter8-setup-authn
chapter8-setup-authn:
	-kubectl delete ns istioinaction
	-kubectl create ns istioinaction
	-kubectl -n default delete -f chapters/chapter8/sleep.yaml
	-istioctl kube-inject -f services/catalog/kubernetes/catalog.yaml | kubectl -n istioinaction apply -f -
	-istioctl kube-inject -f services/apigateway/kubernetes/apigateway.yaml | kubectl -n istioinaction apply -f -
	-kubectl -n default apply -f chapters/chapter8/sleep.yaml
	-kubectl apply -f chapters/chapter8/meshwide-strict-peer-authn.yaml
	-kubectl apply -f chapters/chapter8/workload-permissive-peer-authn.yaml

.PHONY: chapter8-setup-authn-authz
chapter8-setup-authn-authz: chapter8-setup-authn
	-kubectl apply -f chapters/chapter8/policy-deny-all-mesh.yaml
	-kubectl apply -f chapters/chapter8/allow-unauthenticated-view-default-ns.yaml
	-kubectl apply -f chapters/chapter8/catalog-viewer-policy.yaml

.PHONY: chapter8-cleanup
chapter8-cleanup:
	-kubectl delete authorizationpolicy --all -n istio-system 2> /dev/null || true
	-kubectl delete authorizationpolicy --all -n istioinaction 2> /dev/null || true
	-kubectl delete requestauthentication --all -n istio-system 2> /dev/null || true
	-kubectl delete requestauthentication --all -n istioinaction 2> /dev/null || true
	-kubectl delete peerauthentication --all -n istioinaction 2> /dev/null || true
	-kubectl delete peerauthentication default -n istio-system 2> /dev/null || true
	-kubectl delete -f chapters/chapter8/sleep.yaml -n default 2> /dev/null || true
	-kubectl delete ns istioinaction 2> /dev/null || true


