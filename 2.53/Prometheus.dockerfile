# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y tcl

# Download and extract Prometheus.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/prometheus/prometheus/releases/download/v2.53.0/prometheus-2.53.0.linux-amd64.tar.gz --quiet \
  && tar xvzf prometheus-2.53.0.linux-amd64.tar.gz > /dev/null

# Create a directory for Prometheus
RUN set -x \
  && cp -r prometheus-2.53.0.linux-amd64/* /usr/local/lib/prometheus \
  && rm -rf prometheus-2.53.0.linux-amd64* \

# Create Redis directories.
WORKDIR ../
RUN set -x \
  && mkdir /opt/prometheus \
  && mkdir /opt/prometheus/data \
  && mkdir /opt/prometheus/log \
  && mkdir /opt/prometheus/conf \
  && mkdir /opt/prometheus/script \
  && mkdir /opt/prometheus/system \
  && touch /opt/prometheus/system/server.pid \
  && touch /opt/prometheus/system/supervisor.ini \
  && ln -s /opt/prometheus/system/supervisor.ini /etc/supervisord.d/prometheus.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/prometheus
