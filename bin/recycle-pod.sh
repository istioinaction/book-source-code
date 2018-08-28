#!/usr/bin/env bash
UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

DIR_NAME=$(ls -l "$UTILS_DIR/../" | grep $1 | awk '{ print $NF }')
pushd "$UTILS_DIR/../$DIR_NAME"

ls -l

mvn clean
mvn -Dtest=false -DfailIfNoTests=false -DskipITs install
. ./docker-build.sh
POD=$(kubectl get pod | grep 'Running' | grep $1 | awk '{ print $1 }')
kubectl delete pod $POD --force --grace-period=0

popd

kubectl get pod -w
