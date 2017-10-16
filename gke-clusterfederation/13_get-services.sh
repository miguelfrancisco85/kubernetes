#!/bin/bash
name=$1

CLUSTERS="asia-east1-b us-east1-b us-central1-b"

if [ -z $name ] ; then

  echo "Set a name for the service"
  exit 1

fi

#kubectl config use-context federation-cluster

for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} get pods
done

for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} describe services $name
done

for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} describe ingress $name
done
