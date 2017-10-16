#!/bin/bash

kubectl create -f ../k8s/guestbook.rc.yaml --namespace=minefield

kubectl create -f ../k8s/guestbook.service.yaml --namespace=minefield
