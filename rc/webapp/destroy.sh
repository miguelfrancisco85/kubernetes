#!/bin/bash

set -e

VERSION=$1

if [ -z $1 ] ; then
  echo "Set the version to delete"
  exit 1
fi

echo "Removing RC: webapp"
kubectl delete -f webapp-v$VERSION-rc.yaml
echo "Removing Service version: $VERSION"
kubectl delete -f webapp-v$VERSION-svc.yaml
echo "Removing ingress Ports and LB"
kubectl delete -f webapp-ingress.yml
