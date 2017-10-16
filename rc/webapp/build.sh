#!/bin/bash

set -e

VERSION=$1

if [ -z $1 ] ; then
  echo "Set the version to Deploy"
  exit 1
fi

echo "Creating RC: webapp"
kubectl create -f webapp-v$VERSION-rc.yaml
echo "Creating Service version: $VERSION"
kubectl create -f webapp-v$VERSION-svc.yaml
echo "Creating ingress Ports and LB"
kubectl create -f webapp-ingress.yml
