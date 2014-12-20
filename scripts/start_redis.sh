#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/ensure_ownership.sh
exec /sbin/setuser redis /usr/bin/redis-server /etc/redis/redis.conf