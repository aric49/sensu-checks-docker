FROM sstarcher/sensu

env ENVIRONMENT=nonprod \
    HOSTNAME_OVERRIDE=default-undefined \
    CLIENT_ADDRESS=$HOSTNAME_OVERRIDE \
    CLIENT_NAME=checks-dockerd-$HOSTNAME_OVERRIDE

RUN apt-get update && \
    apt-get install libstdc++6 g++ ruby-dev build-essential -y && \
    /opt/sensu/embedded/bin/gem install sensu-plugins-docker sensu-plugins-opsgenie
COPY config/ /etc/sensu/templates
COPY checks /etc/sensu/conf.d/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]





#Testing
#docker run -it  -e CLIENT_DEREGISTER=false -e CLIENT_SUBSCRIPTIONS=all -e REDIS_DB=0 -e REDIS_HOST=sensu-redis.internal.tree.com -e REDIS_PORT=6379 -e REDIS_RECONNECT=true -e SENSU_SERVICE=client -v /var/run/docker.sock:/var/run/docker.sock -v /etc/hostname:/etc/hostname --rm sensu-docker:10
