#!/bin/bash

kubectl --namespace=minefield create -f ../k8s/mongodb-1.rc.yaml
kubectl --namespace=minefield create -f ../k8s/mongodb-2.rc.yaml
kubectl --namespace=minefield create -f ../k8s/mongodb-3.rc.yaml
