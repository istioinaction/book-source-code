

KUBE_RESOURCES := $(shell pwd)/install



#----------------------------------------------------------------------------------
# Deploy services
#----------------------------------------------------------------------------------

.PHONY: deploy-apigateway-with-catalog
deploy-apigateway-with-catalog:
	-istioctl kube-inject -f $(KUBE_RESOURCES)/catalog-service/catalog-all.yaml | kubectl create -f -
	-istioctl kube-inject -f $(KUBE_RESOURCES)/apigateway-service/apigateway-all.yaml | kubectl create -f -
	-kubectl apply -f $(KUBE_RESOURCES)/istio/


.PHONY: undeploy-apigateway-with-catalog
undeploy-apigateway-with-catalog:
	-kubectl delete svc catalog
	-kubectl delete deploy catalog
	-kubectl delete svc apigateway
	-kubectl delete deploy apigateway
	-kubectl delete -f $(KUBE_RESOURCES)/istio/

.PHONY: ingress-url
ingress-url:
	@echo $(shell kubectl get pod -n istio-system -l istio=ingressgateway -o jsonpath='{.items[0].status.hostIP}'):$(shell kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')	


#----------------------------------------------------------------------------------
# Port forward Observability
#----------------------------------------------------------------------------------
.PHONY: pf-grafana
pf-grafana:
	kubectl port-forward -n istio-system $(shell kubectl get pod -n istio-system | grep -i ^grafana | cut -d ' ' -f 1) 3000:3000 > /dev/null 2>&1 &


.PHONY: pf-prom
pf-prom:
	kubectl port-forward -n istio-system $(shell kubectl get pod -n istio-system | grep -i ^prometheus | cut -d ' ' -f 1) 9090:9090 > /dev/null 2>&1 &

.PHONY: pf-kiali
pf-kiali:
	kubectl port-forward -n istio-system $(shell kubectl get pod -n istio-system | grep -i ^kiali | cut -d ' ' -f 1) 8080:20001 > /dev/null 2>&1 &

.PHONY: pf-obs
pf-obs: pf-grafana pf-kiali pf-prom

.PHONY: clean
clean:
		for pid in $(shell ps aux  | awk '/port-forward/ {print $$2}'); do kill -9 $$pid; done

