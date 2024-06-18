#!/bin/sh

set -e

mkdir -p config/generated

# Generate configs for all nodes
for shard in $(seq 1 3); do
    for replica in $(seq 1 2); do
        echo "Generating config for node s$shard-r$replica"
        cp -r config/src/shared/ "config/generated/node-s$shard-r$replica"

        # expand macros
        SHARD="$shard" REPLICA="$replica" \
            envsubst < config/src/templates/macros.xml > "config/generated/node-s$shard-r$replica/macros.xml"

        # for replica 1 of each shard, enable keeper
        if [ "$replica" -eq 1 ]; then
            echo "  Enabling keeper for node s$shard-r$replica"
            SERVER_ID="$shard" \
                envsubst < config/src/templates/enable-keeper.xml > "config/generated/node-s$shard-r$replica/enable-keeper.xml"
        fi
    done
done
