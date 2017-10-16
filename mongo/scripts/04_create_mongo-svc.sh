#!/bin/bash

kubectl --namespace=minefield create -f ../k8s/mongodb-1.service.yaml
kubectl --namespace=minefield create -f ../k8s/mongodb-2.service.yaml
kubectl --namespace=minefield create -f ../k8s/mongodb-3.service.yaml
kubectl --namespace=minefield create -f ../k8s/mongodb.service.yaml
