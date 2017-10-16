#!/bin/bash

PASSWORD=`openssl rand -base64 15`
export PASSWORD
echo "Your password is $PASSWORD"

if [ -f options ] ; then
  rm -f options > /dev/null
fi

cp options.orig options
sed "s|CHANGEME|${PASSWORD}/g" options
