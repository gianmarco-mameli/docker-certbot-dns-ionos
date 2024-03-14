#!/bin/sh

# Set permissions
doas /certbot_permissions.sh

# Configure supercronic schedules
echo "${IONOS_CRONTAB} /certbot_script.sh" | tee -a "/tmp/crontabs/certbot" >/dev/null

# Some startup log
echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"

# execute first time for certificate creation
echo "Fisrt run of certbot"
/certbot_script.sh

#Start supercronic from image CMD
echo "Starting $*"
"$@"