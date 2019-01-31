#!/bin/sh

port=8080
ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip)  -vnNL *:$port:$(minikube ip):$port &
BACKGROUND_PID=$!
echo "Background minikube ssh pid: $BACKGROUND_PID"


# from here: https://rimuhosting.com/knowledgebase/linux/misc/trapping-ctrl-c-in-bash
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
function ctrl_c() {
        echo "** Trapped CTRL-C"
        kill $BACKGROUND_PID

}

# get web container
WEB_CONTAINER=$(kubectl get pod | grep web | cut -d ' ' -f 1)
kubectl port-forward $WEB_CONTAINER $port:$port