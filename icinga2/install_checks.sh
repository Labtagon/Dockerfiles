#!/bin/sh
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y --no-install-recommends kubectl jq curl jshon vim nano python3-pip
pip3 install requests


apt clean
rm -rf /var/lib/apt/lists/*
