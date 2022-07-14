#!/bin/bash

set -e

KEYS=10
NODES=5
FAILURE_TOLERANCE=$((NODES - (NODES / 2 + 1)))

function etcdctl() {
  echo "[NODE${1}] etcdctl ${2}"
  docker-compose exec "etcd-${1}" sh -c "etcdctl ${2}"
  echo
}

function stop-node() {
  echo "[NODE${1}] STOP"
  docker-compose stop "etcd-${1}"
  echo
}

echo "[KEYS = ${KEYS}][NODES = ${NODES}][FAILURE TOLERANCE = ${FAILURE_TOLERANCE}]"
echo

etcdctl $((1 % NODES)) 'member list'

etcdctl $((2 % NODES)) 'del "" --from-key=true'

i=0
while [ $i -lt "$KEYS" ]; do
  etcdctl $((i % NODES + 1)) "put key${i} value${i}"
  i=$((i + 1))
done

NODE=1
while [ $NODE -le "$FAILURE_TOLERANCE" ]; do
  etcdctl $NODE "get --prefix key"
  stop-node $NODE
  NODE=$((NODE + 1))
done

etcdctl $NODES "get --prefix key"

stop-node $NODE

etcdctl $NODES "get --prefix key"