#!/bin/bash

./kubectl config use-context host-cluster

./kubectl config set-cluster federation-cluster \
  --server=https://$(kubectl get services federation-apiserver \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}') \
  --insecure-skip-tls-verify=true

FEDERATION_TOKEN=$(cut -d"," -f1 known-tokens.csv)

./kubectl config set-credentials federation-cluster \
  --token=${FEDERATION_TOKEN}

./kubectl config set-context federation-cluster \
  --cluster=federation-cluster \
  --user=federation-cluster

./kubectl config use-context federation-cluster

mkdir -p kubeconfigs/federation-apiserver

./kubectl config view --flatten --minify > kubeconfigs/federation-apiserver/kubeconfig

./kubectl config use-context host-cluster

./kubectl create secret generic federation-apiserver-kubeconfig \
  --from-file=kubeconfigs/federation-apiserver/kubeconfig

./kubectl describe secrets federation-apiserver-kubeconfig

echo -n "Enter federated dns zone name, not domain name:"
read FEDZONE
export FEDZONE
DNS_ZONE_NAME=$(gcloud dns managed-zones describe $FEDZONE --format='value(dnsName)')
DNS_ZONE_ID=$(gcloud dns managed-zones describe $FEDZONE --format='value(id)')

./kubectl create configmap federation-controller-manager \
  --from-literal=zone-id=${DNS_ZONE_ID} \
  --from-literal=zone-name=${DNS_ZONE_NAME}

./kubectl get configmap federation-controller-manager -o yaml

./kubectl create -f deployments/federation-controller-manager.yaml

./kubectl get pods

./kubectl config use-context federation-cluster

mkdir -p configmaps

rm -f configmaps/kube-dns.yaml

cat > configmaps/kube-dns.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  federations: federation=${DNS_ZONE_NAME}
EOF

./kubectl create -f configmaps/kube-dns.yaml 


