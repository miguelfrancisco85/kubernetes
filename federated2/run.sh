#!/bin/bash
set -e

NAME=$1
ZONE="${2:-asia-northeast1-b}"
gcloud container clusters create $NAME-federated --zone $ZONE

gcloud container clusters get-credentials $NAME-federated --zone $ZONE

gcloud compute addresses create k-$NAME-ingress --global

kubectl --context=kfed create deployment nginx --image=nginx && \
  kubectl --context=kfed scale deployment nginx --replicas=4

kubectl --context=kfed create service nodeport nginx \
  --tcp=80:80 --node-port=30036

gcloud compute firewall-rules create \
  federated-$NAME-ingress-firewall-rule \
  --source-ranges "130.211.0.0/22","91.126.134.2/32" \
  --allow tcp:30036 --network default

kubectl apply -f service.yaml
sed -i s/KINGRESS/k-"${NAME}"-ingress/g ingress.yaml
kubectl apply -f ingress.yaml
