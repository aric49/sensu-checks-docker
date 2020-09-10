#!/bin/bash
set -ex

#Entrypoint Script to dynamically get hostname for the check
function sensu_cleanup {
  echo "Docker Terminated Gracefully Deleteing Client......"
  curl -X DELETE http://sensu-api.my.fqdn.com/clients/checks-dockerd-$HOSTNAME_OVERRIDE
}

function sensu_kill {
  echo "Houston!  We have an issue! Docker went down unexpectedly..."
}

# export HOSTNAME_OVERRIDE=$ENVIRONMENT-$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
export HOSTNAME_OVERRIDE=$ENVIRONMENT-$(hostname)
export CLIENT_ADDRESS=$HOSTNAME_OVERRIDE
export CLIENT_NAME=checks-dockerd-$HOSTNAME_OVERRIDE

trap sensu_cleanup SIGTERM
trap sensu_kill SIGKILL
/usr/bin/dumb-init /bin/start & wait
