#!/bin/bash

./kubectl apply -f rs/healthcheck.yaml
./kubectl apply -f services/healthcheck.yaml
./kubectl apply -f ingress/healtcheck.yaml
