#!/bin/sh

doas /certbot_permissions.sh

echo "${IONOS_CRONTAB} /certbot_script.sh" | tee -a "/tmp/crontabs/certbot" >/dev/null

echo time=\""$(date -Is || true)"\"' level=info msg='\""docker-certbot-dns-ionos v${IONOS_VERSION} started"\"

# echo "docker-certbot-dns-ionos v${IONOS_VERSION} started"
# echo "Starting crond with the following env variables"
# printenv | grep -i "IONOS_"

# Execute CMD
echo time=\""$(date -Is || true)"\"' level=info msg='\""Starting $*"\"
"$@"