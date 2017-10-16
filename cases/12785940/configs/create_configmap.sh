#!/bin/bash
NAME=$1

kubectl create configmap $NAME-config --from-file=nginx.conf
