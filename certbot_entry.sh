#!/bin/sh

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

echo "Starting crond with the following env variables"
printenv | grep -i "IONOS_"