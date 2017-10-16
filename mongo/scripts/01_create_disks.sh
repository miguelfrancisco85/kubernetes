#!/bin/bash

PROJECT=$1
ZONE=$2

gcloud compute disks create --size 200GB mongodb-pd-1 --project=$PROJECT --zone=$ZONE
gcloud compute disks create --size 200GB mongodb-pd-2 --project=$PROJECT --zone=$ZONE
gcloud compute disks create --size 200GB mongodb-pd-3 --project=$PROJECT --zone=$ZONE
