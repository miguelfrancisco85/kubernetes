#!/bin/bash
set -ex 
NAME=$1
ZONE=$2

if [ -z $1 ] ; then

  echo "Set a name for this cluster"
  echo "The region will be appended to the cluster name"
  exit 1

fi

if [ -z $2 ] ; then

  echo "Set the zone name for the cluster"
  exit 1

fi

gcloud container clusters create $NAME-$ZONE --zone $ZONE --num-nodes 5
gcloud container clusters get-credentials $NAME-$ZONE --zone $ZONE

./02_create-disk.sh $NAME $ZONE
