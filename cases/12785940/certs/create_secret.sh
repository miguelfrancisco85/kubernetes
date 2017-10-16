#!/bin/bash
NAME=$1

kubectl create secret tls $NAME-ssl --key $NAME.key --cert $NAME.crt
