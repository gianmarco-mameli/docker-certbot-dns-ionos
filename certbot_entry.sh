#!/bin/sh

echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

echo "${IONOS_CRONTAB} /bin/sh /certbot_script.sh" | tee "/tmp/crontabs/certbot" >/dev/null
echo "Crontab entry ${IONOS_CRONTAB} added"

# touch /etc/environment
echo "Starting crond with the following env variables"
printenv | grep -i "IONOS_"
# | tee -a /etc/environment

# Execute CMD
echo "Executing $*"
exec "$@"