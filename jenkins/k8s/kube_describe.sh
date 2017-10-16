#!/bin/bash

KIND="$1"
NAME="$2"
NS="${3:-default}"

if [ -z $1 ] && [ -z $2 ] && [ -z $3 ] ; then
  echo "Set the Kind, Name of resource and the NAMESPACE (if empty, default)"
  echo "$0 ingress|deploy|pods|svc|rs|rc resourcename notdefault"
  exit 1
fi
  
kubectl describe "$KIND" "$NAME" --namespace $NS
