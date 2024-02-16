#!/bin/sh

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

echo "${IONOS_CRONTAB} sudo -E /bin/sh /certbot_script.sh > /dev/stdout 2>&1" | sudo tee -a "/etc/crontabs/${USERNAME} >/dev/null"
echo "Crontab entry ${IONOS_CRONTAB} added for user ${USERNAME}"

echo "Starting crond"
sudo /usr/sbin/crond -l 8 -f
