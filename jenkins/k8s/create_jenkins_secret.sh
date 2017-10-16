#!/bin/bash

kubectl create secret generic jenkins --from-file=options --namespace=jenkins
