#!/bin/bash

VERSION=1.6.4
GCP_PROJECT="$(gcloud config list --format='value(core.project)')"

gcloud beta container clusters create asia-east1-b \
  --cluster-version $VERSION \
  --zone asia-east1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"

gcloud beta container clusters create us-east1-b \
  --cluster-version $VERSION \
  --zone=us-east1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"

gcloud beta container clusters create us-central1-b \
  --cluster-version $VERSION \
  --zone=us-central1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"

echo "GET CREDENTIALS"
for cluster in asia-east1-b us-east1-b us-central1-b; do
  gcloud container clusters get-credentials ${cluster} \
  --zone ${cluster}
done

echo "GET CONTEXTS"
for cluster in asia-east1-b us-east1-b us-central1-b; do
  kubectl config set-context ${cluster} \
    --cluster=gke_${GCP_PROJECT}_${cluster}_${cluster} \
    --user=gke_${GCP_PROJECT}_${cluster}_${cluster}
done

HOST_CLUSTER="us-central1-b"

kubectl config set-context host-cluster \
  --cluster=gke_${GCP_PROJECT}_${HOST_CLUSTER}_${HOST_CLUSTER} \
  --user=gke_${GCP_PROJECT}_${HOST_CLUSTER}_${HOST_CLUSTER} \
  --namespace=federation

gcloud container clusters list
