CLICKHOUSE_DOCKER_IMAGE = clickhouse/clickhouse-server
# CLICKHOUSE_DOCKER_IMAGE = ch-server

generate-config:
	rm -rf config/generated
	./scripts/generate-configs.sh

rebuild-server:
	docker build -t ch-server docker/server

clean:
	rm -rf config/generated

clean-containers:
	docker compose rm -f

start: generate-config
	docker compose up -d

stop:
	docker compose down

attach-r1:
	docker compose attach clickhouse-s1-r1

attach-r2:
	docker compose attach clickhouse-s2-r2

connect:
	docker run -it --rm --network="clickhouse-net" $(CLICKHOUSE_DOCKER_IMAGE) clickhouse-client --host clickhouse-s1-r1
