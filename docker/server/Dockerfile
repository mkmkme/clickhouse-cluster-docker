# Based on https://github.com/ClickHouse/ClickHouse/blob/master/docker/server/Dockerfile.ubuntu

FROM ubuntu:24.04

# user/group precreated explicitly with fixed uid/gid on purpose.
# It is especially important for rootless containers: in that case entrypoint
# can't do chown and owners of mounted volumes should be configured externally.
# We do that in advance at the begining of Dockerfile before any packages will be
# installed to prevent picking those uid / gid by some unrelated software.
# The same uid / gid (101) is used both for alpine and ubuntu.
RUN groupadd -r clickhouse --gid=101 \
    && useradd -r -g clickhouse --uid=101 --home-dir=/var/lib/clickhouse --shell=/bin/bash clickhouse \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        locales \
        tzdata \
        wget \
    && rm -rf /var/lib/apt/lists/* /var/cache/debconf /tmp/*

COPY clickhouse /tmp/clickhouse_binary/clickhouse

RUN chmod +x /tmp/clickhouse_binary/clickhouse \
        && /tmp/clickhouse_binary/clickhouse install --user "clickhouse" --group "clickhouse" \
        && rm -rf /tmp/* ;

# post install
# we need to allow "others" access to clickhouse folder, because docker container
# can be started with arbitrary uid (openshift usecase)
RUN clickhouse-local -q 'SELECT * FROM system.build_options' \
    && mkdir -p /var/lib/clickhouse /var/log/clickhouse-server /etc/clickhouse-server /etc/clickhouse-client \
    && chmod ugo+Xrw -R /var/lib/clickhouse /var/log/clickhouse-server /etc/clickhouse-server /etc/clickhouse-client

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC

RUN mkdir /docker-entrypoint-initdb.d

COPY entrypoint.sh /entrypoint.sh

EXPOSE 9000 8123 9009
VOLUME /var/lib/clickhouse

ENV CLICKHOUSE_CONFIG /etc/clickhouse-server/config.xml

ENTRYPOINT ["/entrypoint.sh"]
