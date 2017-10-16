#!/bin/bash
DISK=$1
ZONE=$2

if [ -z $1 ] ; then

  echo "Set a name for the disk"
  exit 1

fi

if [ -z $2 ] ; then

  echo "Set a ZONE for the disk"
  exit 1

fi

echo "Y" | gcloud compute disks create $DISK --zone $ZONE
