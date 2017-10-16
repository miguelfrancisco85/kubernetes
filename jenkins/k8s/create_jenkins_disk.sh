#!/bin/bash

CLUSTER=$1
ZONE=$2
PROJECT=$3

if [[ -z $1 || -z $2 || -z $3 ]] ; then
  echo "Set Cluster, Zone and Project-ID"
  echo "$0 <cluster-1> <zone> <project-id>"
  exit 1
fi

gcloud --project $PROJECT compute images create jenkins-home-$CLUSTER-$ZONE --source-uri https://storage.googleapis.com/solutions-public-assets/jenkins-cd/jenkins-home-v3.tar.gz
gcloud --project $PROJECT compute disks create jenkins-home-$CLUSTER-$ZONE --image jenkins-home-$CLUSTER-$ZONE --zone $ZONE
