#!/usr/bin/env bash

help () {
        cat <<EOF
        This script is a collection of request that are used in the book. 
        Below is a list of arguments and the requests that those make:
            - 'get-items' Continuous requests that print the response status code 
            - 'random-agent' Adds either chrome or firefox in the request header.

        Usage: ./bin/query-catalog.sh status-code
EOF
    exit 1
}

TYPE=$1

case ${TYPE} in
    get-items-cont)
        echo "#" curl -s -H \"Host: catalog.istioinaction.io\" -w \"\\nStatus Code %{http_code}\" localhost/items
        echo 
        sleep 2
        while :
        do
            curl -s -H "Host: catalog.istioinaction.io" -w "\nStatus Code %{http_code}\n\n" localhost/items
            sleep .5
        done
        ;;
    get-items)
        echo "#" curl -s -H \"Host: catalog.istioinaction.io\" -w \"\\nStatus Code %{http_code}\" localhost/items
        echo 
        curl -s -H "Host: catalog.istioinaction.io" -w "\nStatus Code %{http_code}" localhost/items
        ;;
    random-agent)
        echo "== REQUEST EXECUTED =="
        echo curl -s -H "Host: catalog.istioinaction.io" -H "User-Agent: RANDOM_AGENT" -w "\nStatus Code %{http_code}\n\n" localhost/items
        echo 
        while :
        do
          useragents=(chrome firefox)
          agent=${useragents[ ($RANDOM % 2) ]}
          curl -s -H "Host: catalog.istioinaction.io" -H "User-Agent: $agent" -w "\nStatus Code %{http_code}\n\n" localhost/items
          sleep .5
        done
        ;;
    delayed-responses)
        CATALOG_POD=$(kubectl get pods -l version=v2 -n istioinaction -o jsonpath={.items..metadata.name} | cut -d ' ' -f1)
        if [ -z "$CATALOG_POD" ]; then
            echo "No pods found with the following query:"
            echo "-> kubectl get pods -l version=v2 -n istioinaction"
            exit 1
        fi

        kubectl -n istioinaction exec -c catalog $CATALOG_POD \
            -- curl -s -X POST -H "Content-Type: application/json" \
            -d '{"active": true,  "type": "latency", "latencyMs": 1000, "volatile": true}' \
            localhost:3000/blowup
        ;;
    *)
        help
        ;;
esac