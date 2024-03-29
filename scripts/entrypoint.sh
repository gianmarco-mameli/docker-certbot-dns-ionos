#!/bin/sh

# Set permissions
doas /certbot_permissions.sh

# Configure supercronic schedules
echo "${IONOS_CRONTAB} /certbot_script.sh" | tee -a "/tmp/crontabs/certbot" >/dev/null

# Some startup log
echo time=\""$(date -Is || true)"\"' level=info msg='\""docker-certbot-dns-ionos v${IONOS_VERSION} started"\"
echo time=\""$(date -Is || true)"\"' level=info msg='\""Starting $*"\"

#Start supercronic from image CMD
"$@"