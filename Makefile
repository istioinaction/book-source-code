

#----------------------------------------------------------------------------------
# Port forward Grafana
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

