#!/bin/bash

CRED_FILE=./credentials.json
echo "Create Secrets with credentials for service account with Cloud SQL access role"
kubectl create secret generic cloudsql-oauth-credentials --from-file=credentials.json="${CRED_FILE}"

echo "Create Secrets with credentials for Cloud SQL DB Access"
kubectl create secret generic cloudsql --from-literal=username=cloudsql --from-literal=password=cloudsql
