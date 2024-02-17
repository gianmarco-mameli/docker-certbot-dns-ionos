#!/bin/sh

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

# sudo -E touch "/etc/crontabs/${USERNAME}"
echo "${IONOS_CRONTAB} /bin/sh /certbot_script.sh > /dev/stdout 2>&1" | sudo -E tee -a /etc/crontabs/root >/dev/null
echo "Crontab entry ${IONOS_CRONTAB} added"

echo "Starting crond"
sudo -E printenv | grep -vi "IONOS_" >> /etc/environment
/usr/sbin/crond -l 8 -f
