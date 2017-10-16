#!/bin/bash
VERSION=${1:-v1.0}

export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
gcloud config set compute/zone us-central1-a

echo "Create App Engine in us-central"
gcloud beta app create --region=us-central

echo "Creating Docker containers"
docker build -t frontend:$VERSION frontend/
docker build -t backend:$VERSION backend-dummy/
docker build -t backend:$VERSION backend-smart/

echo "Running the Docker Containers locally"

docker run -d --name backend -e PROJECT_ID=$PROJECT_ID backend:$VERSION
docker run -d --name frontend -p 8080:8080 -e PROJECT_ID=$PROJECT_ID \
  --link backend:backend frontend:$VERSION

echo "Testing the API"
API_URL=http://localhost:8080/api/v1 client/client.py
echo #######################


echo "Stop Docker Containers..."
docker stop frontend backend
docker rm frontend backend

echo "Tagging the Images and Pushing to gcr.io"
docker tag frontend:$VERSION gcr.io/$PROJECT_ID/frontend:$VERSION
docker tag backend:$VERSION gcr.io/$PROJECT_ID/backend:$VERSION
docker tag backend:$VERSION gcr.io/$PROJECT_ID/backend:$VERSION

echo "Caching new Docker images from gcr.io"
gcloud docker -- push gcr.io/$PROJECT_ID/frontend:$VERSION
gcloud docker -- push gcr.io/$PROJECT_ID/backend:$VERSION
gcloud docker -- push gcr.io/$PROJECT_ID/backend:$VERSION

echo "Creating cluster"
gcloud container clusters create gobang-cluster-$VERSION \
  --num-nodes 3 \
  --scopes "https://www.googleapis.com/auth/datastore"

echo "Getting Kubernetes Credentials from cluster"
gcloud container clusters get-credentials gobang-cluster-$VERSION

echo "Deploy frontend and backend Pods, changing project ID"
sed -i "s/<PROJECT ID>/$PROJECT_ID/" config/frontend-deployment.yaml
sed -i "s/<PROJECT ID>/$PROJECT_ID/" config/backend-deployment.yaml
echo "Creating Kubernetes Services"
kubectl create -f config/frontend-service.yaml
kubectl create -f config/backend-service.yaml

echo "Get Services"
kubectl get services

