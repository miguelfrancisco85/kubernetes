#!/bin/bash
VERSION="1.6.4"

curl -O https://storage.googleapis.com/kubernetes-release/release/v$VERSION/bin/linux/amd64/kubectl
curl -O https://storage.googleapis.com/kubernetes-release/release/v$VERSION/bin/linux/amd64/kubefed

chmod a+x kubectl
chmod a+x kubefed
