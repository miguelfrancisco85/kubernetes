#!/bin/bash

./kubectl config use-context host-cluster

./kubectl create -f ns/federation.yaml

./kubectl create -f services/federation-apiserver.yaml

./kubectl get services
sleep 160

FEDERATION_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')

$(rm -f known-tokens.csv > /dev/null)

cat > known-tokens.csv <<EOF
${FEDERATION_TOKEN},admin,admin
EOF

./kubectl create secret generic federation-apiserver-secrets \
  --from-file=known-tokens.csv

./kubectl describe secrets federation-apiserver-secrets

./kubectl create -f pvc/federation-apiserver-etcd.yaml

 export ADVERTISE_ADDRESS=$(kubectl get services federation-apiserver -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

./kubectl create configmap federated-apiserver \
  --from-literal=advertise-address=$ADVERTISE_ADDRESS

./kubectl get configmap federated-apiserver \
  -o jsonpath='{.data.advertise-address}'

./kubectl create -f deployments/federation-apiserver.yaml
