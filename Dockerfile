FROM fluent/fluentd
MAINTAINER shanestarcher@gmail.com

RUN gem install -N fluent-plugin-docker_metadata_filter
RUN gem install -N fluent-plugin-redis-store
RUN gem install -N fluent-plugin-record-reformer
RUN gem install -N fluent-plugin-record-modifier
RUN gem install -N fluent-plugin-rename-key
RUN gem install -N fluent-plugin-grep

ENV REDIS_HOST logging.private
ENV REDIS_PORT 6379
USER root
