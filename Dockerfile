FROM fluent/fluentd:v0.14-latest
MAINTAINER shanestarcher@gmail.com

RUN gem install -N fluent-plugin-docker_metadata_filter
RUN gem install -N fluent-plugin-redis-store
RUN gem install -N fluent-plugin-record-reformer
RUN gem install -N fluent-plugin-record-modifier
RUN gem install -N fluent-plugin-rename-key
RUN gem install -N fluent-plugin-grep
RUN gem install -N fluent-plugin-ec2-metadata

USER root
ENV REDIS_HOST logging.private
ENV REDIS_PORT 6379
VOLUME ["/fluent/containers"]

COPY fluent.conf /fluentd/etc/


