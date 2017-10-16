#!/bin/bash
set -e

NAME=$1
ZONE="${2:-asia-northeast1-b}"
echo "Y" | gcloud container clusters delete $NAME-federated --zone $ZONE


gcloud compute addresses delete k-$NAME-ingress --global

gcloud compute firewall-rules delete \
  federated-$NAME-ingress-firewall-rule \
   --network default

