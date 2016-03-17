FROM clojure
MAINTAINER Rackspace Managed Security <rms-engineering@rackspace.com>

# npm would not be necessary with a separate build container; it is only used
# for testing. However, omitting it currently breaks the build. See issues:
# https://github.com/RackSec/desdemona/issues/79
# https://github.com/RackSec/desdemona/issues/76
RUN apt-get update && apt-get upgrade -y && apt-get install -y npm

# Add Desdemona to the Docker container.
COPY . /usr/src/desdemona
WORKDIR /usr/src/desdemona

# Cache the dependencies.
# RUN lein deps

RUN mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')" /srv/desdemona.jar

RUN mkdir /etc/service/onyx_peer
COPY script/run_peers.sh /etc/service/onyx_peer/run
RUN mkdir /etc/service/aeron
COPY script/run_aeron.sh /etc/service/aeron/run

EXPOSE 40200/tcp
EXPOSE 40200/udp

CMD ["/sbin/my_init"]
