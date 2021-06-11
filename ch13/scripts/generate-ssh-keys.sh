#!/bin/bash

set -ex

keys_dir=`dirname "$BASH_SOURCE"`/../keys

echo "== Clean up contents of dir './ch13/keys_dir' =="
rm -rf ${keys_dir}

echo
echo "== Generating new dir =="
mkdir -p ${keys_dir}

echo "== Generating new ssh key =="
ssh-keygen -b 2048 -t rsa -C info@istioinaction.io -f "${keys_dir}/id_rsa" -q -N ""
chmod 0600 "${keys_dir}/id_rsa"
