#!/bin/bash
set -ex
#Entrypoint Script to dynamically get hostname for the check
function sensu_cleanup {
  echo "Deleteing Client......"
  curl -X DELETE http://sensu-api.internal.tree.com/clients/checks-dockerd-$HOSTNAME_OVERRIDE
}

export HOSTNAME_OVERRIDE=$ENVIRONMENT-$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
export CLIENT_ADDRESS=$HOSTNAME_OVERRIDE
export CLIENT_NAME=checks-dockerd-$HOSTNAME_OVERRIDE

/usr/bin/dumb-init /bin/start
