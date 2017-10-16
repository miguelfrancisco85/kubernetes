#!/bin/bash

VERSION=1.6.4
GCP_PROJECT="$(gcloud config list --format='value(core.project)')"

echo "Y" | gcloud container clusters delete asia-east1-b \
  --zone asia-east1-b

echo "Y" | gcloud beta container clusters delete us-east1-b \
  --zone=us-east1-b

echo "Y" | gcloud beta container clusters delete us-central1-b \
  --zone=us-central1-b

gcloud container clusters list

> ~/.kube/config
