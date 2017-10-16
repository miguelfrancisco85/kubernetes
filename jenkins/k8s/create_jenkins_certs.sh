#!/bin/bash
CERTNAME="$1"
KEY_FILE="/tmp/$CERTNAME.key"
CRT_FILE="/tmp/$CERTNAME.crt"

if [ -z "$1" ] ; then
  echo "Set the name for the key."
  echo "Will be create two files, Key: /tmp/NAME.key and Crt: /tmp/NAME.crt"
  echo "i.e. $0 jenkins"
  exit 1
fi 

if [ -f $KEY_FILE ] && [ -f $CRT_FILE ] ; then
  echo "$KEY_FILE and $CRT_FILE already exist."
  echo "Backing up your files: "
  echo "mv $KEY_FILE $CERTNAME.bak && rm -f $KEY_FILE"
  echo "mv $CRT_NAME $CERTNAME.bak && rm -f $CRT_FILE"
  echo "Done"
fi 

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$KEY_FILE" -out "$CRT_FILE" -subj "/CN=$CERTNAME/O=$CERTNAME"
