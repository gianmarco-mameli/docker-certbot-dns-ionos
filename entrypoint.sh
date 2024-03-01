#!/bin/sh

echo "@reboot /certbot_entry.sh" | tee "/tmp/crontabs/certbot" >/dev/null
echo "${IONOS_CRONTAB} /certbot_script.sh" | tee "/tmp/crontabs/certbot" >/dev/null

# Execute CMD
"$@"
