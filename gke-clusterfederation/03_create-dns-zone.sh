#!/bin/bash
set -ex

NAME=$1
DOMAIN=$2

if [ -z $1 ] ; then
  echo "Set the name for the DNS Zone Federation"
  echo "$0 federationtest fed"
  exit 1
fi

if [ -z $2 ] ; then
  echo "Set a domain name for the DNS Zone"
  echo "$0 federationtest fed"
  exit 1
fi

$(gcloud dns managed-zones delete $NAME > /dev/null)

gcloud dns managed-zones create $NAME \
  --description "Kubernetes federation $NAME" \
  --dns-name $NAME.$DOMAIN
