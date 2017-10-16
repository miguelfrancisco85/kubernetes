#!/bin/bash

kubectl config use-context host-cluster
CLUSTERS="asia-east1-b us-east1-b us-central1-b"

rm -rf clusters
rm -rf kubeconfigs
mkdir -p clusters
mkdir -p kubeconfigs

for cluster in ${CLUSTERS}; do
  mkdir -p kubeconfigs/${cluster}/

  SERVER=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(endpoint)')

  CERTIFICATE_AUTHORITY_DATA=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(masterAuth.clusterCaCertificate)')

  CLIENT_CERTIFICATE_DATA=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(masterAuth.clientCertificate)')

  CLIENT_KEY_DATA=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(masterAuth.clientKey)')

  ./kubectl config set-cluster ${cluster} --kubeconfig kubeconfigs/${cluster}/kubeconfig

  ./kubectl config set clusters.${cluster}.server \
    "https://${SERVER}" \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  ./kubectl config set clusters.${cluster}.certificate-authority-data \
    ${CERTIFICATE_AUTHORITY_DATA} \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  ./kubectl config set-credentials admin --kubeconfig kubeconfigs/${cluster}/kubeconfig

  ./kubectl config set users.admin.client-certificate-data \
    ${CLIENT_CERTIFICATE_DATA} \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  ./kubectl config set users.admin.client-key-data \
    ${CLIENT_KEY_DATA} \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  ./kubectl config set-context default \
    --cluster=${cluster} \
    --user=admin \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  ./kubectl config use-context default \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  cat > clusters/${cluster}.yaml <<EOF
apiVersion: federation/v1beta1
kind: Cluster
metadata:
  name: ${cluster}
spec:
  serverAddressByClientCIDRs:
    - clientCIDR: "0.0.0.0/0"
      serverAddress: "https://${SERVER}"
  secretRef:
    name: ${cluster}
EOF
done

for cluster in ${CLUSTERS}; do
  kubectl create secret generic ${cluster} \
    --from-file=kubeconfigs/${cluster}/kubeconfig
done

./kubectl config use-context federation-cluster
./kubectl create -f clusters/
./kubectl get clusters
