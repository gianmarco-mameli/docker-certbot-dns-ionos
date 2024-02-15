#!/bin/sh

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

echo "${IONOS_CRONTAB} /bin/sh /certbot_script.sh > /dev/stdout 2>&1" | sudo tee -a /etc/crontabs/root >/dev/null
echo "Crontab entry ${IONOS_CRONTAB} added"

echo "Starting crond"
sudo /usr/sbin/crond -l 8 -f
