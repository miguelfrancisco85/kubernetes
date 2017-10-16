#!/bin/bash
CERTNAME="$1"
KEY_FILE="/tmp/$CERTNAME.key"
CRT_FILE="/tmp/$CERTNAME.crt"
set -e

if [ -z "$1" ] ; then
  echo "Set the name for the key."
  echo "Will be create two files, Key: /tmp/NAME.key and Crt: /tmp/NAME.crt"
  echo "i.e. $0 jenkins"
  exit 1
fi 
if [ ! -f $KEY_FILE ] && [ ! -f $CRT_FILE ] ; then
  echo "$KEY_FILE and $CRT_FILE does not exist."
  echo "mv $KEY_FILE $CERTNAME.bak && rm -f $KEY_FILE"
  echo "mv $CRT_NAME $CERTNAME.bak && rm -f $CRT_FILE"
  echo "Done"
fi 

kubectl create secret generic tls --from-file="$CRT_FILE" --from-file="$KEY_FILE" --namespace jenkins
