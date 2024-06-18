# Clickhouse cluster with docker-compose

This is a simple example of how to run a clickhouse cluster with docker-compose.

## How to run
1. Install docker-compose (https://docs.docker.com/compose/install/)
2. Create a `clickhouse-net` network via `docker network create clickhouse-net`
3. Run `make start` to start the cluster
4. Run `make connect` to connect to the cluster
5. Run `make stop` to stop the cluster
6. Run `make clean` to clean up the cluster
7. Run `make clean-containers` to clean up the docker containers

Additionally, you can run `make attach-r1` to attach to the first replica
container or `make attach-r2` to attach to the second replica container.
This can be useful for looking at the logs in real time.

## How it works
The cluster is composed of 3 shards (s1, s2, s3) with 2 replicas (r1, r2) per
shard. Each replica is a separate docker container.
First replica of each shard is used to also serve clickhouse-keeper.

The cluster can be configured to use the `ch-server` docker image, which is a
customized version of the official clickhouse image. To build `ch-server`:

1. Put `clickhouse` binary in `./docker/server/` directory
2. Run `make build-server`


## Credits
* [jneo8/clickhouse-setup](https://github.com/jneo8/clickhouse-setup)
* Karan Sharma's [article](https://mrkaran.dev/posts/clickhouse-replication/) and
  [example repository](https://github.com/mr-karan/clickhouse-keeper-example)
* [ClickHouse cluster deployment documentation](https://clickhouse.com/docs/en/architecture/cluster-deployment)
* [ClickHouse horizontal scaling documentation](https://clickhouse.com/docs/en/architecture/horizontal-scaling)
