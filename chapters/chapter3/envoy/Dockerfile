FROM envoyproxy/envoy:v1.7.0
MAINTAINER Christian Posta (christian.posta@gmail.com)

COPY conf/simple.yaml /etc/envoy
COPY conf/simple_change_timeout.yaml /etc/envoy
COPY conf/simple_retry.yaml /etc/envoy

CMD /usr/local/bin/envoy --v2-config-only -l $loglevel -c /etc/envoy/envoy.yaml