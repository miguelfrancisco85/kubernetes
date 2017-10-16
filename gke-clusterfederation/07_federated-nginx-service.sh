#!/bin/bash
CLUSTERS="asia-east1-b us-east1-b us-central1-b"
kubectl config use-context federation-cluster
kubectl create -f rs/nginx.yaml
kubectl get rs

for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} get pods
done

#kubectl config use-context federation-cluster

kubectl create -f services/nginx.yaml

kubectl describe services nginx

for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} describe services nginx
done
