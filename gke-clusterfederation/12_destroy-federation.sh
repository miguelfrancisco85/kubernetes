#!/bin/bash

if [ -f kubectl ] ; then
  echo "Kubectl executable not in place, download it first"
  exit 1
fi

./kubectl delete -f deployments/
./kubectl delete -f services/
./kubectl delete -f configmaps/kube-dns.yaml 
./kubectl delete -f deployments/
./kubectl delete -f ns/
./kubectl delete -f pvc/
