#!/bin/sh
echo "${IONOS_CRONTAB} /bin/sh /certbot_script.sh > /dev/stdout 2>&1" >> /etc/crontabs/root

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started

/usr/sbin/crond -l 8 -f