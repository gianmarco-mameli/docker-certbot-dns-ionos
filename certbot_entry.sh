#!/bin/sh

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

echo "${IONOS_CRONTAB} /bin/sh /certbot_script.sh > /dev/stdout 2>&1" | sudo -E tee -a /etc/crontabs/root >/dev/null
echo "Crontab entry ${IONOS_CRONTAB} added"

sudo touch /etc/environment
echo "Starting crond with the following env variables"
printenv | grep -i "IONOS_" | sudo -E tee -a /etc/environment
/usr/sbin/crond -l 8 -f
