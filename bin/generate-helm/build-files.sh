#!/bin/sh
DIRECTORY=$(cd `dirname $0` && pwd)


rm -fr $DIRECTORY/../../install
mkdir $DIRECTORY/../../install

sh $DIRECTORY/00-helm-istio-starter.sh
sh $DIRECTORY/10-helm-istio-minimal.sh
sh $DIRECTORY/30-helm-istio-minimal-addons.sh
sh $DIRECTORY/40-helm-istio-medium.sh
sh $DIRECTORY/50-helm-istio-almost-full.sh
sh $DIRECTORY/60-helm-istio-full.sh
sh $DIRECTORY/crds.sh