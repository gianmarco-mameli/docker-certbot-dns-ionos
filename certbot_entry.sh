#!/bin/sh

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

echo "${IONOS_CRONTAB} /bin/sh ${CERTBOT_BASE_DIR}/certbot_script.sh" | tee -a "${CERTBOT_CRONTABS_DIR}/${USERNAME} >/dev/null"
echo "Crontab entry ${IONOS_CRONTAB} added"

# touch /etc/environment
echo "Starting crond with the following env variables"
printenv | grep -i "IONOS_"
# | tee -a /etc/environment
/usr/sbin/crond -f -c "${CERTBOT_CRONTABS_DIR}"
