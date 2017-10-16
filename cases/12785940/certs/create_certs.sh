#!/bin/bash
NAME="$1"
SSL_CERTIFICATE="$NAME"
CRT_FILE_PATH="$NAME.crt"
KEY_FILE_PATH="$NAME.key"

openssl genrsa -out $NAME.key 2048
openssl req -new -key $NAME.key -out $NAME.csr
openssl x509 -req -days 365 -in $NAME.csr -signkey $NAME.key -out $NAME.crt

#
gcloud compute ssl-certificates create $SSL_CERTIFICATE \
        --certificate $CRT_FILE_PATH \
        --private-key $KEY_FILE_PATH

gcloud compute ssl-certificates describe $SSL_CERTIFICATE

gcloud compute ssl-certificates list
